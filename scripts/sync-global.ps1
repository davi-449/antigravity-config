# sync-global.ps1
# Synchronizes the antigravity-config repo (source of truth) to ~/.gemini/config/ (global active copy).
# Usage: .\sync-global.ps1 [-DryRun] [-ShowDiff]

param(
    [switch]$DryRun,
    [switch]$ShowDiff
)

$ErrorActionPreference = "Stop"

# --- Paths ---
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$globalConfig = Join-Path $env:USERPROFILE ".gemini\config"

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host " Antigravity Config Sync: Repo -> Global" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "Repo Root:     $repoRoot" -ForegroundColor White
Write-Host "Global Config: $globalConfig" -ForegroundColor White
Write-Host ""

# --- Sync Mappings ---
$syncMap = @(
    @{ Source = "skills";                Dest = "skills";                 Type = "dir"  },
    @{ Source = ".agent\agents";         Dest = "skills\.agents";         Type = "dir"  },
    @{ Source = ".agent\rules\ia.md";    Dest = "rules\ia.md";            Type = "file" },
    @{ Source = "schemas";               Dest = "skills\.agents\schemas"; Type = "dir"  }
)

$totalCopied = 0
$totalSkipped = 0
$errors = @()

foreach ($mapping in $syncMap) {
    $srcPath = Join-Path $repoRoot $mapping.Source
    $dstPath = Join-Path $globalConfig $mapping.Dest

    if (-not (Test-Path $srcPath)) {
        Write-Host "[SKIP] Source not found: $($mapping.Source)" -ForegroundColor Yellow
        $totalSkipped++
        continue
    }

    if ($mapping.Type -eq "dir") {
        $srcFiles = Get-ChildItem -Path $srcPath -Recurse -File
        $fileCount = $srcFiles.Count

        if ($DryRun) {
            Write-Host "[DRY]  $($mapping.Source) -> $($mapping.Dest) ($fileCount files)" -ForegroundColor Yellow
        } else {
            if (-not (Test-Path $dstPath)) {
                New-Item -ItemType Directory -Path $dstPath -Force | Out-Null
            }

            $robocopyArgs = @($srcPath, $dstPath, "/MIR", "/NJH", "/NJS", "/NDL", "/NC", "/NS")
            $null = & robocopy @robocopyArgs

            if ($LASTEXITCODE -le 7) {
                Write-Host "[OK]   $($mapping.Source) -> $($mapping.Dest) ($fileCount files)" -ForegroundColor Green
                $totalCopied += $fileCount
            } else {
                $errMsg = "Robocopy failed for $($mapping.Source) with code $LASTEXITCODE"
                Write-Host "[FAIL] $errMsg" -ForegroundColor Red
                $errors += $errMsg
            }
        }
    }
    elseif ($mapping.Type -eq "file") {
        if ($DryRun) {
            Write-Host "[DRY]  $($mapping.Source) -> $($mapping.Dest)" -ForegroundColor Yellow
        } else {
            $dstDir = Split-Path -Parent $dstPath
            if (-not (Test-Path $dstDir)) {
                New-Item -ItemType Directory -Path $dstDir -Force | Out-Null
            }

            Copy-Item -Path $srcPath -Destination $dstPath -Force
            Write-Host "[OK]   $($mapping.Source) -> $($mapping.Dest)" -ForegroundColor Green
            $totalCopied++
        }
    }
}

# --- Cleanup redundant global files that cause system prompt triplication ---
$redundantFiles = @("GEMINI.md", "AGENTS.md")
foreach ($rf in $redundantFiles) {
    $rfPath = Join-Path $globalConfig $rf
    if (Test-Path $rfPath) {
        if ($DryRun) {
            Write-Host "[DRY]  Remove redundant duplicate: $rf" -ForegroundColor Yellow
        } else {
            Remove-Item -Path $rfPath -Force
            Write-Host "[CLEAN] Removed duplicate prompt file: $rf (eliminates 2.3k tokens overhead)" -ForegroundColor Cyan
        }
    }
}

# --- Show Diff ---
if ($ShowDiff) {
    Write-Host ""
    Write-Host "--- Diff: Repo vs Global ---" -ForegroundColor Cyan

    foreach ($m in $syncMap) {
        if ($m.Type -eq "file") {
            $srcP = Join-Path $repoRoot $m.Source
            $dstP = Join-Path $globalConfig $m.Dest

            if ((Test-Path $srcP) -and (Test-Path $dstP)) {
                $srcH = (Get-FileHash -Path $srcP -Algorithm SHA256).Hash
                $dstH = (Get-FileHash -Path $dstP -Algorithm SHA256).Hash

                if ($srcH -eq $dstH) {
                    Write-Host "[MATCH] $($m.Dest)" -ForegroundColor Green
                } else {
                    Write-Host "[DIFF]  $($m.Dest) - hashes differ!" -ForegroundColor Red
                }
            }
        }
    }
}

# --- Summary ---
Write-Host ""
Write-Host "=============================================" -ForegroundColor Cyan
if ($DryRun) {
    Write-Host " DRY RUN COMPLETE - no files modified" -ForegroundColor Yellow
} else {
    Write-Host " SYNC COMPLETE" -ForegroundColor Green
    Write-Host " Files synced: $totalCopied" -ForegroundColor White
    Write-Host " Skipped:      $totalSkipped" -ForegroundColor White
    if ($errors.Count -gt 0) {
        Write-Host " Errors:       $($errors.Count)" -ForegroundColor Red
        foreach ($e in $errors) {
            Write-Host "   - $e" -ForegroundColor Red
        }
    }
}
Write-Host "=============================================" -ForegroundColor Cyan
