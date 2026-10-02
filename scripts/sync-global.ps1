# sync-global.ps1
# Synchronizes the antigravity-config repo (source of truth) to ~/.gemini/config/ (global active copy).
# Usage: .\sync-global.ps1 [-DryRun] [-ShowDiff]

param(
    [switch]$DryRun,
    [switch]$ShowDiff,
    [string]$GlobalConfigPath = ""
)

$ErrorActionPreference = "Stop"

# --- Paths ---
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$globalConfig = if ($GlobalConfigPath) { [IO.Path]::GetFullPath($GlobalConfigPath) } else { Join-Path $env:USERPROFILE ".gemini\config" }

Write-Host "=============================================" -ForegroundColor Cyan
Write-Host " Antigravity Config Sync: Repo -> Global" -ForegroundColor Cyan
Write-Host "=============================================" -ForegroundColor Cyan
Write-Host "Repo Root:     $repoRoot" -ForegroundColor White
Write-Host "Global Config: $globalConfig" -ForegroundColor White
Write-Host ""

# --- Sync Mappings ---
$syncMap = @(
    @{ Source = "skills";                Dest = "skills";                 Type = "dir"  },
    @{ Source = ".agents\agents";        Dest = "agents";                 Type = "dir"  },
    @{ Source = ".agent\rules\ia.md";    Dest = "rules\ia.md";            Type = "file" }
)

$totalCopied = 0
$totalSkipped = 0
$errors = @()
$conflicts = @()

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
    if (Test-Path -LiteralPath $Destination -PathType Leaf) {
        $sourceHash = (Get-FileHash -LiteralPath $Source -Algorithm SHA256).Hash
        $targetHash = (Get-FileHash -LiteralPath $Destination -Algorithm SHA256).Hash
        if ($sourceHash -ne $targetHash) {
            if (-not (Test-KnownSourceVersion -Source $Source -Destination $Destination)) {
                Write-Host "[CONFLICT] Existing file preserved: $Destination" -ForegroundColor Yellow
                $script:conflicts += $Destination
                return
            }
            if ($DryRun) {
                Write-Host "[DRY]  Would update verified prior version: $Destination" -ForegroundColor Yellow
                return
            }
            Copy-Item -LiteralPath $Source -Destination $Destination -Force
            Write-Host "[UPDATE] Verified prior version: $Destination" -ForegroundColor Green
            $script:totalCopied++
            return
        }
        $script:totalSkipped++
        return
    }
    if ($DryRun) {
        Write-Host "[DRY]  Would copy $Destination" -ForegroundColor Yellow
        return
    }
    New-Item -ItemType Directory -Path (Split-Path -Parent $Destination) -Force | Out-Null
    Copy-Item -LiteralPath $Source -Destination $Destination
    $script:totalCopied++
}

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
        foreach ($srcFile in $srcFiles) {
            $relative = $srcFile.FullName.Substring($srcPath.Length).TrimStart([IO.Path]::DirectorySeparatorChar)
            Copy-IfSafe -Source $srcFile.FullName -Destination (Join-Path $dstPath $relative)
        }
        Write-Host "[CHECKED] $($mapping.Source) -> $($mapping.Dest) ($fileCount files)" -ForegroundColor Cyan
    }
    elseif ($mapping.Type -eq "file") {
        Copy-IfSafe -Source $srcPath -Destination $dstPath
    }
}

# --- Report possible duplicates; never delete files of unverified origin ---
$redundantFiles = @("GEMINI.md", "AGENTS.md")
foreach ($rf in $redundantFiles) {
    $rfPath = Join-Path $globalConfig $rf
    if (Test-Path $rfPath) {
        Write-Host "[REVIEW] Existing $rf preserved; verify its origin before removing a duplicate rule." -ForegroundColor Yellow
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
    Write-Host " Conflicts preserved: $($conflicts.Count)" -ForegroundColor $(if ($conflicts.Count) { 'Yellow' } else { 'White' })
    if ($errors.Count -gt 0) {
        Write-Host " Errors:       $($errors.Count)" -ForegroundColor Red
        foreach ($e in $errors) {
            Write-Host "   - $e" -ForegroundColor Red
        }
    }
}
Write-Host "=============================================" -ForegroundColor Cyan
if ($errors.Count -gt 0 -or $conflicts.Count -gt 0) { exit 1 }
