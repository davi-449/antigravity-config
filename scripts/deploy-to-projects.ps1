# deploy-to-projects.ps1
# Instala o Antigravity Config v7 Native AGY Edition (Single-Agent, Plan-First, DESIGN.md Semântico)
# em todos os projetos e repositórios locais em ~/.gemini/antigravity/scratch/.
# Usage: .\deploy-to-projects.ps1 [-DryRun] [-ProjectName <name>] [-ScratchPath <path>]

param(
    [switch]$DryRun,
    [string]$ProjectName = "",
    [string]$ScratchPath = ""
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$scratchDir = if ($ScratchPath) { [IO.Path]::GetFullPath($ScratchPath) } else { "C:\Users\admin\.gemini\antigravity\scratch" }

Write-Host "=================================================" -ForegroundColor Magenta
Write-Host " Antigravity v7 Native - Deployment Engine       " -ForegroundColor Magenta
Write-Host "=================================================" -ForegroundColor Magenta
Write-Host "Source:  $repoRoot" -ForegroundColor White
Write-Host "Target:  $scratchDir" -ForegroundColor White
Write-Host ""

# Exclude internal/system/infrastructure folders
$excludeNames = @(
    "antigravity-config-main",
    "antigravity_arquivos",
    "mingit",
    "node_modules",
    "config.zip"
)

$projects = @(Get-ChildItem -LiteralPath $scratchDir -Directory | Where-Object {
    ($excludeNames -notcontains $_.Name) -and (-not $ProjectName -or $_.Name -eq $ProjectName)
})
if ($ProjectName -and $projects.Count -ne 1) { throw "Project '$ProjectName' was not found in $scratchDir." }

function Test-KnownSourceVersion {
    param([string]$Source, [string]$Destination)
    $relative = $Source.Substring($repoRoot.Length).TrimStart([IO.Path]::DirectorySeparatorChar).Replace('\', '/')
    $destinationBlob = ((& git -C $repoRoot hash-object -- $Destination) -join '').Trim()
    if ($LASTEXITCODE -ne 0 -or -not $destinationBlob) { return $false }
    $knownBlobs = @(& git -C $repoRoot rev-list --objects --all -- $relative 2>$null)
    if ($LASTEXITCODE -ne 0) { return $false }
    return @($knownBlobs | Where-Object { $_ -match "^$([regex]::Escape($destinationBlob))\s" }).Count -gt 0
}

function Copy-IfSafe {
    param([string]$Source, [string]$Destination)
    if (-not (Test-Path -LiteralPath $Source -PathType Leaf)) { return }
    if (Test-Path -LiteralPath $Destination -PathType Leaf) {
        $sourceHash = (Get-FileHash -LiteralPath $Source -Algorithm SHA256).Hash
        $targetHash = (Get-FileHash -LiteralPath $Destination -Algorithm SHA256).Hash
        if ($sourceHash -ne $targetHash) {
            if (-not (Test-KnownSourceVersion -Source $Source -Destination $Destination)) {
                Write-Host "    [CONFLICT] Existing file preserved: $Destination" -ForegroundColor Yellow
                $script:conflictCount++
                return
            }
            if ($DryRun) {
                Write-Host "    [DRY] Would update verified prior version: $Destination" -ForegroundColor Yellow
                return
            }
            Copy-Item -LiteralPath $Source -Destination $Destination -Force
            Write-Host "    [UPDATE] Verified prior version: $Destination" -ForegroundColor Green
            return
        }
        Write-Host "    [SAME] $Destination" -ForegroundColor DarkGray
        return
    }
    if ($DryRun) {
        Write-Host "    [DRY] Would copy: $Destination" -ForegroundColor Yellow
        return
    }
    New-Item -ItemType Directory -Path (Split-Path -Parent $Destination) -Force | Out-Null
    Copy-Item -LiteralPath $Source -Destination $Destination
    Write-Host "    [NEW] $Destination" -ForegroundColor Green
}

Write-Host "Found $($projects.Count) target projects:" -ForegroundColor Cyan
foreach ($p in $projects) {
    Write-Host "  - $($p.Name)" -ForegroundColor White
}
Write-Host ""

$sourceDesign = Join-Path $repoRoot "DESIGN.md"
$sourceSkills = Join-Path $repoRoot "skills"

$successCount = 0
$failCount = 0
$conflictCount = 0

foreach ($project in $projects) {
    $projPath = $project.FullName
    $conflictsBefore = $conflictCount
    Write-Host "--> Deploying v7 to: $($project.Name)..." -ForegroundColor Yellow

    try {
        # The global rule is installed by sync-global.ps1. Preserve project-owned root rules.
        foreach ($ruleName in @('AGENTS.md', 'GEMINI.md')) {
            if (Test-Path -LiteralPath (Join-Path $projPath $ruleName)) {
                Write-Host "    [REVIEW] Existing $ruleName preserved; check for duplicate rules." -ForegroundColor Yellow
            }
        }
        $localIa = Join-Path $projPath '.agent/rules/ia.md'
        if (Test-Path -LiteralPath $localIa) {
            # Existing local constitutions may override the global rule. Update only a verified prior version.
            Copy-IfSafe -Source (Join-Path $repoRoot '.agent/rules/ia.md') -Destination $localIa
        }

        # 1. Ensure .agent memory structure without overwriting project memory.
        $targetAgent = Join-Path $projPath ".agent"
        # 2. Copy project defaults only when the target path is absent or identical.
        Copy-IfSafe -Source $sourceDesign -Destination (Join-Path $projPath "DESIGN.md")

        # 3. Copy skills file by file. Never mirror-delete or overwrite local variants.
        $targetSkills = Join-Path $projPath "skills"
        foreach ($skillFile in (Get-ChildItem -LiteralPath $sourceSkills -Recurse -File)) {
            $relative = $skillFile.FullName.Substring($sourceSkills.Length).TrimStart([IO.Path]::DirectorySeparatorChar)
            Copy-IfSafe -Source $skillFile.FullName -Destination (Join-Path $targetSkills $relative)
        }

        # 4. Copy documentation without overwriting project-owned edits.
        $targetDocs = Join-Path $projPath "docs"
        $sourceManual = Join-Path $repoRoot "docs\manual-operacao-antigravity.md"
        Copy-IfSafe -Source $sourceManual -Destination (Join-Path $targetDocs "manual-operacao-antigravity.md")

        # 5. Copy the feature catalog only if it has no local changes.
        $targetSpecsGlobal = Join-Path $projPath "specs\global"
        $sourceFeatures = Join-Path $repoRoot "specs\global\features.md"
        Copy-IfSafe -Source $sourceFeatures -Destination (Join-Path $targetSpecsGlobal "features.md")

        # 6. Copy .github templates without replacing existing templates.
        $targetGithub = Join-Path $projPath ".github"
        $sourcePrTemplate = Join-Path $repoRoot ".github\PULL_REQUEST_TEMPLATE.md"
        Copy-IfSafe -Source $sourcePrTemplate -Destination (Join-Path $targetGithub "PULL_REQUEST_TEMPLATE.md")
        $targetWorkflows = Join-Path $targetGithub "workflows"
        $sourceQualityWorkflow = Join-Path $repoRoot ".github\workflows\quality.yml.example"
        Copy-IfSafe -Source $sourceQualityWorkflow -Destination (Join-Path $targetWorkflows "quality.yml.example")

        # 7. Bootstrap Obsidian memory only where the category is absent.
        $targetMemory = Join-Path $targetAgent "memory"
        $sourceMemory = Join-Path $repoRoot ".agent\memory"
        if (Test-Path $sourceMemory) {
            $categories = @("ui", "supabase", "auth", "infra", "domain")
            foreach ($cat in $categories) {
                $targetCatFile = Join-Path $targetMemory "$cat.md"
                Copy-IfSafe -Source (Join-Path $sourceMemory "$cat.md") -Destination $targetCatFile
            }
        }

        if ($conflictCount -gt $conflictsBefore) {
            Write-Host "    [REVIEW] Existing custom files were preserved; inspect conflicts above." -ForegroundColor Yellow
            $failCount++
        } else {
            Write-Host "    [OK] Canonical files checked." -ForegroundColor Green
            $successCount++
        }
    }
    catch {
        Write-Host "    [FAIL] Error: $($_.Exception.Message)" -ForegroundColor Red
        $failCount++
    }
}

Write-Host ""
Write-Host "=================================================" -ForegroundColor Magenta
Write-Host " Deployment Complete" -ForegroundColor Magenta
Write-Host " Success: $successCount projects" -ForegroundColor Green
Write-Host " Failed:  $failCount projects" -ForegroundColor $(if ($failCount -gt 0) { "Red" } else { "White" })
Write-Host " Conflicts preserved: $conflictCount" -ForegroundColor $(if ($conflictCount -gt 0) { "Yellow" } else { "White" })
Write-Host "=================================================" -ForegroundColor Magenta
if ($failCount -gt 0 -or $conflictCount -gt 0) { exit 1 }
