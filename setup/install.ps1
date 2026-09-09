# install.ps1
# Bootstrap completo do Antigravity Config - verifica prerequisitos, configura agy, sincroniza global.
# Usage: .\install.ps1 [-CheckOnly] [-SkipAgy] [-Native]

param(
    [switch]$CheckOnly,
    [switch]$SkipAgy,
    [switch]$Native
)

$ErrorActionPreference = "Stop"
$setupRoot = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $setupRoot

Write-Host ""
Write-Host "===============================================" -ForegroundColor Magenta
Write-Host " Antigravity Config v6 - Bootstrap Installer" -ForegroundColor Magenta
Write-Host "===============================================" -ForegroundColor Magenta
Write-Host ""

$checks = @{
    git = $false
    node = $false
    powershell = $false
    agy = $false
    graphify = $false
}
$allPassed = $true

# ===== 1. PowerShell Version =====
Write-Host "[1/6] Checking PowerShell..." -ForegroundColor Cyan
$psVersion = $PSVersionTable.PSVersion
if ($psVersion.Major -ge 5) {
    Write-Host "  OK: PowerShell $psVersion" -ForegroundColor Green
    $checks.powershell = $true
} else {
    Write-Host "  WARN: PowerShell $psVersion (recomendado 5.1+)" -ForegroundColor Yellow
    $allPassed = $false
}

# ===== 2. Git =====
Write-Host "[2/6] Checking Git..." -ForegroundColor Cyan
$gitCmd = Get-Command git -ErrorAction SilentlyContinue
$mingitPath = "C:\Users\admin\.gemini\antigravity\scratch\mingit\cmd\git.exe"

if ($gitCmd) {
    $gitVersion = & git --version 2>&1
    Write-Host "  OK: $gitVersion" -ForegroundColor Green
    $checks.git = $true
} elseif (Test-Path $mingitPath) {
    $gitVersion = & $mingitPath --version 2>&1
    Write-Host "  OK (fallback): $gitVersion at $mingitPath" -ForegroundColor Green
    $checks.git = $true
} else {
    Write-Host "  FAIL: Git not found in PATH or fallback location" -ForegroundColor Red
    $allPassed = $false
}

# ===== 3. Node.js =====
Write-Host "[3/6] Checking Node.js..." -ForegroundColor Cyan
$nodeCmd = Get-Command node -ErrorAction SilentlyContinue
if ($nodeCmd) {
    $nodeVersion = & node --version 2>&1
    Write-Host "  OK: Node.js $nodeVersion" -ForegroundColor Green
    $checks.node = $true
} else {
    Write-Host "  WARN: Node.js not found (needed only for build gates)" -ForegroundColor Yellow
}

# ===== 4. agy CLI =====
if (-not $SkipAgy -and -not $Native) {
    Write-Host "[4/6] Checking agy CLI..." -ForegroundColor Cyan
    $agyCmd = Get-Command agy -ErrorAction SilentlyContinue
    $wingetPath = "C:\Users\admin\AppData\Local\Microsoft\WinGet\Packages\Google.AntigravityCLI_Microsoft.Winget.Source_8wekyb3d8bbwe\agy.exe"

    if ($agyCmd) {
        Write-Host "  OK: agy at $($agyCmd.Source)" -ForegroundColor Green
        $checks.agy = $true
    } elseif (Test-Path $wingetPath) {
        Write-Host "  OK: agy at $wingetPath" -ForegroundColor Green
        $checks.agy = $true
    } else {
        Write-Host "  WARN: agy CLI not found. Workers will use native Antigravity subagents." -ForegroundColor Yellow
        Write-Host "  Install with: winget install Google.AntigravityCLI" -ForegroundColor Yellow
    }
} else {
    Write-Host "[4/6] Skipping agy CLI (SkipAgy or Native mode specified)" -ForegroundColor Yellow
}

# ===== 5. Graphify =====
Write-Host "[5/6] Checking Graphify..." -ForegroundColor Cyan
$graphifyCmd = Get-Command graphify -ErrorAction SilentlyContinue
if ($graphifyCmd) {
    Write-Host "  OK: graphify at $($graphifyCmd.Source)" -ForegroundColor Green
    $checks.graphify = $true
} else {
    Write-Host "  WARN: graphify not found. Install with: uv tool install graphifyy" -ForegroundColor Yellow
}

# ===== 6. Git Identity =====
Write-Host "[6/6] Checking Git identity..." -ForegroundColor Cyan
$gitExe = if ($gitCmd) { "git" } else { $mingitPath }
if ($checks.git) {
    $gitEmail = & $gitExe config user.email 2>&1
    if ($gitEmail -and $gitEmail -notmatch "fatal") {
        Write-Host "  OK: Git user = $gitEmail" -ForegroundColor Green
    } else {
        if (-not $CheckOnly) {
            & $gitExe config --global user.email "ai@clawhub.com"
            & $gitExe config --global user.name "Antigravity Agent"
            Write-Host "  CONFIGURED: Git identity set to ai@clawhub.com" -ForegroundColor Green
        } else {
            Write-Host "  WARN: Git identity not configured (will set on install)" -ForegroundColor Yellow
        }
    }
}

# ===== Summary =====
Write-Host ""
Write-Host "===============================================" -ForegroundColor Cyan
Write-Host " Pre-requisite Check Results:" -ForegroundColor Cyan
Write-Host "===============================================" -ForegroundColor Cyan

foreach ($key in $checks.Keys) {
    $status = if ($checks[$key]) { "[PASS]" } else { "[----]" }
    $color = if ($checks[$key]) { "Green" } else { "Yellow" }
    Write-Host "  $status $key" -ForegroundColor $color
}

$workerMode = if ($checks.agy -and -not $Native) { "agy CLI (primary) + native (fallback)" } else { "native Antigravity 2.0 only" }
Write-Host ""
Write-Host "  Worker execution mode: $workerMode" -ForegroundColor Cyan

if ($CheckOnly) {
    Write-Host ""
    Write-Host "  CHECK ONLY mode - no changes made." -ForegroundColor Yellow
    Write-Host "===============================================" -ForegroundColor Cyan
    exit 0
}

# ===== Sync Global Config =====
Write-Host ""
Write-Host "[SYNC] Synchronizing repo -> global config..." -ForegroundColor Cyan

$syncScript = Join-Path $repoRoot "scripts\sync-global.ps1"
if (Test-Path $syncScript) {
    & powershell -ExecutionPolicy Bypass -File $syncScript
} else {
    Write-Host "  WARN: sync-global.ps1 not found at $syncScript" -ForegroundColor Yellow
}

# ===== Run Eval Harness (DryRun) =====
Write-Host ""
Write-Host "[EVAL] Running eval harness in DryRun mode..." -ForegroundColor Cyan

$evalScript = Join-Path $repoRoot "scripts\run-evals.ps1"
if (Test-Path $evalScript) {
    & powershell -ExecutionPolicy Bypass -File $evalScript -DryRun
} else {
    Write-Host "  WARN: run-evals.ps1 not found at $evalScript" -ForegroundColor Yellow
}

# ===== Final Report =====
Write-Host ""
Write-Host "===============================================" -ForegroundColor Green
Write-Host " BOOTSTRAP COMPLETE" -ForegroundColor Green
Write-Host " Worker mode: $workerMode" -ForegroundColor White
Write-Host " Config synced to: $env:USERPROFILE\.gemini\config" -ForegroundColor White
Write-Host "===============================================" -ForegroundColor Green
