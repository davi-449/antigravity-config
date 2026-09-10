# tests/benchmark/run-benchmark.ps1
# Runner principal do Antigravity Performance Benchmark Suite

[CmdletBinding()]
param (
    [ValidateSet("current", "optimized")]
    [string]$Profile = "current",

    [switch]$Compare,

    [string]$ReportPath = ""
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent (Split-Path -Parent $ScriptDir)

if (-not $ReportPath) {
    $ReportPath = Join-Path $ScriptDir "reports/${Profile}_report.json"
}

$GradersPath = Join-Path $ScriptDir "graders/benchmark_graders.ps1"
$FixturesDir = Join-Path $ScriptDir "fixtures"

if (-not (Test-Path $GradersPath)) {
    Write-Error "Graders file not found: $GradersPath"
    exit 1
}

# Import graders
. $GradersPath

Write-Host "`n=======================================================" -ForegroundColor Cyan
Write-Host "   Antigravity Performance Benchmark Suite" -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "Profile:     $Profile"
Write-Host "Repo Root:   $RepoRoot"
Write-Host "Timestamp:   $((Get-Date).ToString('yyyy-MM-dd HH:mm:ss'))"
Write-Host "-------------------------------------------------------`n"

# --- Compare mode ---
if ($Compare) {
    $baselinePath = Join-Path $ScriptDir "reports/current_report.json"
    $optimizedPath = Join-Path $ScriptDir "reports/optimized_report.json"

    if (-not (Test-Path $baselinePath) -or -not (Test-Path $optimizedPath)) {
        Write-Error "Both current_report.json and optimized_report.json must exist for comparison."
        exit 1
    }

    $baseline = (Get-Content $baselinePath -Raw -Encoding UTF8) | ConvertFrom-Json
    $optimized = (Get-Content $optimizedPath -Raw -Encoding UTF8) | ConvertFrom-Json

    Write-Host "=== COMPARISON: current vs optimized ===" -ForegroundColor Yellow
    Write-Host ""
    Write-Host "                  CURRENT    OPTIMIZED    DELTA" -ForegroundColor White
    Write-Host "  Total Tests:    $($baseline.summary.total_tests)          $($optimized.summary.total_tests)"
    Write-Host "  Passed:         $($baseline.summary.passed_tests)          $($optimized.summary.passed_tests)          $(($optimized.summary.passed_tests - $baseline.summary.passed_tests))" -ForegroundColor $(if ($optimized.summary.passed_tests -ge $baseline.summary.passed_tests) { "Green" } else { "Red" })
    Write-Host "  Failed:         $($baseline.summary.failed_tests)          $($optimized.summary.failed_tests)          $(($optimized.summary.failed_tests - $baseline.summary.failed_tests))" -ForegroundColor $(if ($optimized.summary.failed_tests -le $baseline.summary.failed_tests) { "Green" } else { "Red" })
    Write-Host "  Pass Rate:      $($baseline.summary.pass_rate_pct)%       $($optimized.summary.pass_rate_pct)%"
    Write-Host ""

    # Compare context budget metrics if available
    $baseCtx = $baseline.dimensions | Where-Object { $_.dimension -eq "context_budget" }
    $optCtx = $optimized.dimensions | Where-Object { $_.dimension -eq "context_budget" }

    if ($baseCtx -and $optCtx) {
        Write-Host "=== CONTEXT BUDGET COMPARISON ===" -ForegroundColor Yellow
        foreach ($bt in $baseCtx.results) {
            $ot = $optCtx.results | Where-Object { $_.TestId -eq $bt.TestId } | Select-Object -First 1
            if ($ot) {
                $bSym = if ($bt.Passed) { "[PASS]" } else { "[FAIL]" }
                $oSym = if ($ot.Passed) { "[PASS]" } else { "[FAIL]" }
                $color = if ($ot.Passed -and -not $bt.Passed) { "Green" } elseif ($ot.Passed) { "White" } else { "Red" }
                Write-Host "  $bSym -> $oSym  $($bt.TestName)" -ForegroundColor $color
            }
        }
    }

    Write-Host "`n=======================================================" -ForegroundColor Cyan
    exit 0
}

# --- Normal benchmark run ---
$allResults = @()
$dimensionResults = @()

# Dimension 1: Instruction Adherence
Write-Host "1. Instruction Adherence (IFEval-style)..." -ForegroundColor Yellow
$iaFixture = Join-Path $FixturesDir "instruction_adherence.json"
if (Test-Path $iaFixture) {
    $iaResults = Test-InstructionAdherence -FixturePath $iaFixture -RepoRoot $RepoRoot
    foreach ($r in $iaResults) {
        $color = if ($r.Passed) { "Green" } else { "Red" }
        $symbol = if ($r.Passed) { "[PASS]" } else { "[FAIL]" }
        Write-Host "  $symbol $($r.TestId): $($r.TestName) ($($r.PassedC)/$($r.Total) constraints)" -ForegroundColor $color
        $allResults += [PSCustomObject]@{
            TestId = $r.TestId; TestName = $r.TestName; Passed = $r.Passed; Details = ($r.Details -join "; ")
        }
    }
    $dimensionResults += [PSCustomObject]@{
        dimension = "instruction_adherence"
        results = $iaResults
    }
}

# Dimension 2: Circuit Breaker Compliance
Write-Host "`n2. Circuit Breaker Compliance..." -ForegroundColor Yellow
$cbFixture = Join-Path $FixturesDir "circuit_breaker_stress.json"
if (Test-Path $cbFixture) {
    $cbResults = Test-CircuitBreakerCompliance -FixturePath $cbFixture -RepoRoot $RepoRoot
    foreach ($r in $cbResults) {
        $color = if ($r.Passed) { "Green" } else { "Red" }
        $symbol = if ($r.Passed) { "[PASS]" } else { "[FAIL]" }
        Write-Host "  $symbol $($r.TestId): $($r.TestName)" -ForegroundColor $color
        $allResults += [PSCustomObject]@{
            TestId = $r.TestId; TestName = $r.TestName; Passed = $r.Passed; Details = $r.Details
        }
    }
    $dimensionResults += [PSCustomObject]@{
        dimension = "circuit_breaker_stress"
        results = $cbResults
    }
}

# Dimension 3: Reasoning Quality (fixture validation)
Write-Host "`n3. Reasoning Quality Fixtures..." -ForegroundColor Yellow
$rqFixture = Join-Path $FixturesDir "reasoning_quality.json"
if (Test-Path $rqFixture) {
    $rqResults = Test-ReasoningQualityFixtures -FixturePath $rqFixture
    foreach ($r in $rqResults) {
        $color = if ($r.Passed) { "Green" } else { "Red" }
        $symbol = if ($r.Passed) { "[PASS]" } else { "[FAIL]" }
        Write-Host "  $symbol $($r.TestId): $($r.TestName) [Difficulty: $($r.Difficulty)]" -ForegroundColor $color
        $allResults += [PSCustomObject]@{
            TestId = $r.TestId; TestName = $r.TestName; Passed = $r.Passed; Details = $r.Details
        }
    }
    $dimensionResults += [PSCustomObject]@{
        dimension = "reasoning_quality"
        results = $rqResults
    }
}

# Dimension 4: Context Budget
Write-Host "`n4. Context Budget Analysis ($Profile)..." -ForegroundColor Yellow
$ctxFixture = Join-Path $FixturesDir "context_budget.json"
if (Test-Path $ctxFixture) {
    $ctxResults = Test-ContextBudget -FixturePath $ctxFixture -RepoRoot $RepoRoot -Profile $Profile
    foreach ($r in $ctxResults) {
        $color = if ($r.Passed) { "Green" } else { "Red" }
        $symbol = if ($r.Passed) { "[PASS]" } else { "[FAIL]" }
        Write-Host "  $symbol $($r.TestId): $($r.TestName)" -ForegroundColor $color
        if ($r.Details) { Write-Host "    -> $($r.Details)" -ForegroundColor DarkGray }
        $allResults += [PSCustomObject]@{
            TestId = $r.TestId; TestName = $r.TestName; Passed = $r.Passed; Details = $r.Details
        }
    }
    $dimensionResults += [PSCustomObject]@{
        dimension = "context_budget"
        results = $ctxResults
    }
}

# Summary
$summary = Get-BenchmarkSummary -AllResults $allResults

Write-Host "`n=======================================================" -ForegroundColor Cyan
Write-Host "   Benchmark Summary ($Profile)" -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "Total Tests:       $($summary.TotalTests)"
Write-Host "Passed:            $($summary.Passed)" -ForegroundColor Green
Write-Host "Failed:            $($summary.Failed)" -ForegroundColor $(if ($summary.Failed -eq 0) { "Green" } else { "Red" })
Write-Host "Pass Rate:         $($summary.PassRate)%" -ForegroundColor $(if ($summary.PassRate -eq 100) { "Green" } else { "Yellow" })
Write-Host "Status:            $($summary.Status)" -ForegroundColor $(if ($summary.Status -eq "BENCHMARK_PASSED") { "Green" } else { "Red" })
Write-Host "-------------------------------------------------------`n"

# Generate report
$reportObject = [PSCustomObject]@{
    timestamp  = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
    profile    = $Profile
    environment = [PSCustomObject]@{
        os_platform = $env:OS
        ps_version  = $PSVersionTable.PSVersion.ToString()
        repo_root   = $RepoRoot
    }
    summary = [PSCustomObject]@{
        total_tests    = $summary.TotalTests
        passed_tests   = $summary.Passed
        failed_tests   = $summary.Failed
        pass_rate_pct  = $summary.PassRate
        status         = $summary.Status
    }
    dimensions  = $dimensionResults
    test_results = $allResults
}

$reportDir = Split-Path -Parent $ReportPath
if (-not (Test-Path $reportDir)) {
    New-Item -Path $reportDir -ItemType Directory -Force | Out-Null
}
$reportJson = $reportObject | ConvertTo-Json -Depth 8
[System.IO.File]::WriteAllText($ReportPath, $reportJson, [System.Text.Encoding]::UTF8)
Write-Host "Report saved to: $ReportPath" -ForegroundColor Cyan

if ($summary.Failed -gt 0) {
    exit 1
} else {
    exit 0
}
