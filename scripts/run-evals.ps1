# scripts/run-evals.ps1
# Runner script for Antigravity Evaluation Harness & Governance System

[CmdletBinding()]
param (
    [ValidateSet("Fixture", "Trace")]
    [string]$Mode = "Fixture",

    [string]$TracePath = "",

    [switch]$DryRun,

    [string]$ReportPath = ""
)

$ErrorActionPreference = "Stop"
$ScriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = Split-Path -Parent $ScriptDir

if (-not $ReportPath) {
    $ReportPath = Join-Path $RepoRoot "tests/eval-harness/reports/eval_report.json"
}

$GradersPath = Join-Path $RepoRoot "tests/eval-harness/graders/deterministic_graders.ps1"
$SchemaPath  = Join-Path $RepoRoot "tests/eval-harness/schemas/fixture_schema.json"
$FixturesDir = Join-Path $RepoRoot "tests/eval-harness/fixtures"

if (-not (Test-Path $GradersPath)) {
    Write-Error "Graders file not found at: $GradersPath"
    exit 1
}

# Import graders
. $GradersPath

Write-Host "`n=======================================================" -ForegroundColor Cyan
Write-Host "   Antigravity Evaluation Harness Runner" -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "Mode:        $Mode"
Write-Host "Repo Root:   $RepoRoot"
Write-Host "Dry Run:     $($DryRun.IsPresent)"
Write-Host "Timestamp:   $((Get-Date).ToString('yyyy-MM-dd HH:mm:ss'))"
Write-Host "-------------------------------------------------------`n"

$testResults = @()
$fixtureFiles = Get-ChildItem -Path $FixturesDir -Filter "*.json"

# 1. Evaluate Fixtures and Assertions
Write-Host "1. Evaluating Fixtures and Assertions..." -ForegroundColor Yellow

foreach ($file in $fixtureFiles) {
    # Schema check
    $schemaRes = Test-FixtureSchemaConformance -FixturePath $file.FullName -SchemaPath $SchemaPath
    $testResults += [PSCustomObject]@{
        Category = "SchemaConformance"
        TestName = $schemaRes.TestName
        Passed   = $schemaRes.Passed
        Details  = $schemaRes.Details
    }

    $color = if ($schemaRes.Passed) { "Green" } else { "Red" }
    $symbol = if ($schemaRes.Passed) { "[PASS]" } else { "[FAIL]" }
    Write-Host "  $symbol $($schemaRes.TestName)" -ForegroundColor $color

    # Assertions inside fixture
    try {
        $rawJson = Get-Content -Path $file.FullName -Raw -Encoding UTF8
        $fixture = $rawJson | ConvertFrom-Json
        foreach ($assertion in $fixture.assertions) {
            $assertRes = Evaluate-Assertion -Assertion $assertion -RepoRoot $RepoRoot
            $testResults += [PSCustomObject]@{
                Category = "FixtureAssertion ($($fixture.id))"
                TestName = $assertRes.Name
                Passed   = $assertRes.Passed
                Details  = "$($assertRes.Target): $($assertRes.Details)"
            }
            $aColor = if ($assertRes.Passed) { "Green" } else { "Red" }
            $aSymbol = if ($assertRes.Passed) { "[PASS]" } else { "[FAIL]" }
            Write-Host "    $aSymbol $($assertRes.Name)" -ForegroundColor $aColor
        }
    }
    catch {
        Write-Warning "Could not parse assertions in $($file.Name): $_"
    }
}

# 2. Evaluate Governance Rules
Write-Host "`n2. Evaluating Governance Rules and Budgets..." -ForegroundColor Yellow
$govResults = Evaluate-GovernanceRules -RepoRoot $RepoRoot
foreach ($gov in $govResults) {
    $testResults += [PSCustomObject]@{
        Category = "GovernanceRule"
        TestName = $gov.TestName
        Passed   = $gov.Passed
        Details  = $gov.Details
    }
    $gColor = if ($gov.Passed) { "Green" } else { "Red" }
    $gSymbol = if ($gov.Passed) { "[PASS]" } else { "[FAIL]" }
    Write-Host "  $gSymbol $($gov.TestName)" -ForegroundColor $gColor
}

# 3. Optional Trace Evaluation
if ($Mode -eq "Trace" -and $TracePath) {
    Write-Host "`n3. Evaluating Execution Trace: $TracePath..." -ForegroundColor Yellow
    $traceRes = Evaluate-ExecutionTrace -TracePath $TracePath
    $testResults += [PSCustomObject]@{
        Category = "TraceAudit"
        TestName = $traceRes.TestName
        Passed   = $traceRes.Passed
        Details  = $traceRes.Details
    }
    $tColor = if ($traceRes.Passed) { "Green" } else { "Red" }
    $tSymbol = if ($traceRes.Passed) { "[PASS]" } else { "[FAIL]" }
    Write-Host "  $tSymbol $($traceRes.TestName) -> $($traceRes.Details)" -ForegroundColor $tColor
}

# 4. Summary & Report Generation
$totalTests = $testResults.Count
$passedTests = ($testResults | Where-Object { $_.Passed -eq $true }).Count
$failedTests = $totalTests - $passedTests
$passRate = if ($totalTests -gt 0) { [math]::Round(($passedTests / $totalTests) * 100, 2) } else { 0 }
$auditStatus = if ($failedTests -eq 0 -and $totalTests -gt 0) { "AUDIT_PASSED" } else { "AUDIT_FAILED" }

Write-Host "`n=======================================================" -ForegroundColor Cyan
Write-Host "   Evaluation Summary" -ForegroundColor Cyan
Write-Host "=======================================================" -ForegroundColor Cyan
Write-Host "Total Checks:      $totalTests"
Write-Host "Passed:            $passedTests" -ForegroundColor Green
Write-Host "Failed:            $failedTests" -ForegroundColor $(if ($failedTests -eq 0) { "Green" } else { "Red" })
Write-Host "Pass Rate:         $passRate%" -ForegroundColor $(if ($passRate -eq 100) { "Green" } else { "Yellow" })
Write-Host "Audit Status:      $auditStatus" -ForegroundColor $(if ($auditStatus -eq "AUDIT_PASSED") { "Green" } else { "Red" })
Write-Host "-------------------------------------------------------`n"

$reportObject = [PSCustomObject]@{
    timestamp           = (Get-Date).ToString("yyyy-MM-ddTHH:mm:ssZ")
    mode                = $Mode
    dry_run             = [bool]$DryRun.IsPresent
    environment         = [PSCustomObject]@{
        os_platform     = $env:OS
        ps_version      = $PSVersionTable.PSVersion.ToString()
        repo_root       = $RepoRoot
    }
    summary             = [PSCustomObject]@{
        total_tests     = $totalTests
        passed_tests    = $passedTests
        failed_tests    = $failedTests
        pass_rate_pct   = $passRate
        status          = $auditStatus
    }
    target_benchmarks   = [PSCustomObject]@{
        schema_conformance_target              = "100%"
        rule_compliance_target                 = "100%"
        forbidden_commands_detection_target    = "100%"
        note                                   = "All percentages represent configured target benchmarks verified deterministically by graders."
    }
    test_results        = $testResults
}

if (-not $DryRun) {
    $reportDir = Split-Path -Parent $ReportPath
    if (-not (Test-Path $reportDir)) {
        New-Item -Path $reportDir -ItemType Directory -Force | Out-Null
    }
    $reportJson = $reportObject | ConvertTo-Json -Depth 6
    [System.IO.File]::WriteAllText($ReportPath, $reportJson, [System.Text.Encoding]::UTF8)
    Write-Host "Report saved to: $ReportPath" -ForegroundColor Cyan
} else {
    Write-Host "Dry-Run mode active: No report file written to disk." -ForegroundColor Yellow
}

if ($failedTests -gt 0) {
    exit 1
} else {
    exit 0
}
