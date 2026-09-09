# deploy-to-projects.ps1
# Instala o Antigravity Config v6 (Leads/Workers, agy integration, ia.md, GEMINI.md, AGENTS.md)
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
Write-Host " Antigravity v6 - Multi-Project Local Deployment" -ForegroundColor Magenta
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
$sourceSchemas = Join-Path $repoRoot "schemas"
$sourceSpawn = Join-Path $repoRoot "scripts\spawn-agy-worker.ps1"

$successCount = 0
$failCount = 0

foreach ($project in $projects) {
    $projPath = $project.FullName
    Write-Host "--> Deploying to: $($project.Name)..." -ForegroundColor Yellow

    if ($DryRun) {
        Write-Host "    [DRY RUN] Would install .agent/ rules, agents, schemas, GEMINI.md, AGENTS.md" -ForegroundColor Yellow
        $successCount++
        continue
    }

    try {
        # 1. Ensure .agent structure
        $targetAgent = Join-Path $projPath ".agent"
        $targetRules = Join-Path $targetAgent "rules"
        $targetAgents = Join-Path $targetAgent "agents"
        $targetSchemas = Join-Path $targetAgent "schemas"
        $targetScripts = Join-Path $targetAgent "scripts"

        New-Item -ItemType Directory -Path $targetRules -Force | Out-Null
        New-Item -ItemType Directory -Path $targetAgents -Force | Out-Null
        New-Item -ItemType Directory -Path $targetSchemas -Force | Out-Null
        New-Item -ItemType Directory -Path $targetScripts -Force | Out-Null

        # 2. Copy ia.md
        Copy-Item -Path $sourceIa -Destination (Join-Path $targetRules "ia.md") -Force

        # 3. Copy GEMINI.md and AGENTS.md to root
        Copy-Item -Path $sourceIa -Destination (Join-Path $projPath "GEMINI.md") -Force
        Copy-Item -Path $sourceIa -Destination (Join-Path $projPath "AGENTS.md") -Force

        # 4. Copy agents hierarchy (leads, workers, README)
        $robocopyArgs = @($sourceAgents, $targetAgents, "/MIR", "/NJH", "/NJS", "/NDL", "/NC", "/NS")
        $null = & robocopy @robocopyArgs

        # 5. Copy schemas
        $robocopyArgs2 = @($sourceSchemas, $targetSchemas, "/MIR", "/NJH", "/NJS", "/NDL", "/NC", "/NS")
        $null = & robocopy @robocopyArgs2

        # 6. Copy spawn-agy-worker helper
        Copy-Item -Path $sourceSpawn -Destination (Join-Path $targetScripts "spawn-agy-worker.ps1") -Force

        # 6.1 Ensure DESIGN.md exists in project root (do not overwrite existing)
        $targetDesign = Join-Path $projPath "DESIGN.md"
        $sourceDesign = Join-Path $repoRoot "DESIGN.md"
        if ((Test-Path $sourceDesign) -and (-not (Test-Path $targetDesign))) {
            Copy-Item -Path $sourceDesign -Destination $targetDesign -Force
            Write-Host "    Created default DESIGN.md" -ForegroundColor DarkCyan
        }

        # 7. Clean up deprecated workflows if present
        $legacyWorkflows = Join-Path $targetAgent "workflows"
        if (Test-Path $legacyWorkflows) {
            Remove-Item -Path $legacyWorkflows -Recurse -Force -ErrorAction SilentlyContinue
            Write-Host "    Cleaned deprecated .agent/workflows/" -ForegroundColor DarkGray
        }

        # 8. Clean up obsolete flat agents in project
        Get-ChildItem -Path $targetAgents -Filter "*-agent.md" -File | Remove-Item -Force -ErrorAction SilentlyContinue

        Write-Host "    [OK] Installed v6 config successfully" -ForegroundColor Green
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
