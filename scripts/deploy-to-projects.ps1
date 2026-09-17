# deploy-to-projects.ps1
# Instala o Antigravity Config v7 Native AGY Edition (Single-Agent, Plan-First, DESIGN.md Semântico)
# em todos os projetos e repositórios locais em ~/.gemini/antigravity/scratch/.
# Usage: .\deploy-to-projects.ps1 [-DryRun]

param(
    [switch]$DryRun
)

$ErrorActionPreference = "Stop"

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$scratchDir = "C:\Users\admin\.gemini\antigravity\scratch"

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

$projects = Get-ChildItem -Path $scratchDir -Directory | Where-Object {
    $excludeNames -notcontains $_.Name
}

Write-Host "Found $($projects.Count) target projects:" -ForegroundColor Cyan
foreach ($p in $projects) {
    Write-Host "  - $($p.Name)" -ForegroundColor White
}
Write-Host ""

$sourceIa = Join-Path $repoRoot ".agent\rules\ia.md"
$sourceAgents = Join-Path $repoRoot ".agent\agents"
$sourceDesign = Join-Path $repoRoot "DESIGN.md"
$sourceSkills = Join-Path $repoRoot "skills"

$successCount = 0
$failCount = 0

foreach ($project in $projects) {
    $projPath = $project.FullName
    Write-Host "--> Deploying v7 to: $($project.Name)..." -ForegroundColor Yellow

    if ($DryRun) {
        Write-Host "    [DRY RUN] Would install v7 config" -ForegroundColor Yellow
        $successCount++
        continue
    }

    try {
        # 1. Ensure .agent structure
        $targetAgent = Join-Path $projPath ".agent"
        $targetRules = Join-Path $targetAgent "rules"
        $targetAgents = Join-Path $targetAgent "agents"

        New-Item -ItemType Directory -Path $targetRules -Force | Out-Null
        New-Item -ItemType Directory -Path $targetAgents -Force | Out-Null

        # 2. Copy ia.md (Constitution v7)
        Copy-Item -Path $sourceIa -Destination (Join-Path $targetRules "ia.md") -Force
        Copy-Item -Path $sourceIa -Destination (Join-Path $projPath "GEMINI.md") -Force
        Copy-Item -Path $sourceIa -Destination (Join-Path $projPath "AGENTS.md") -Force

        # 3. Clean up obsolete multi-agent leads/workers from projects
        if (Test-Path (Join-Path $targetAgents "leads")) {
            Remove-Item -Recurse -Force (Join-Path $targetAgents "leads") -ErrorAction SilentlyContinue
        }
        if (Test-Path (Join-Path $targetAgents "workers")) {
            Remove-Item -Recurse -Force (Join-Path $targetAgents "workers") -ErrorAction SilentlyContinue
        }
        if (Test-Path (Join-Path $projPath ".council")) {
            Remove-Item -Recurse -Force (Join-Path $projPath ".council") -ErrorAction SilentlyContinue
        }

        # 4. Copy DESIGN.md (Semantic Tokens)
        Copy-Item -Path $sourceDesign -Destination (Join-Path $projPath "DESIGN.md") -Force

        # 5. Mirror lean skills/ to project
        $targetSkills = Join-Path $projPath "skills"
        $robocopySkills = @($sourceSkills, $targetSkills, "/MIR", "/NJH", "/NJS", "/NDL", "/NC", "/NS")
        $null = & robocopy @robocopySkills

        Write-Host "    [OK] Installed v7 Native config successfully" -ForegroundColor Green
        $successCount++
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
Write-Host "=================================================" -ForegroundColor Magenta