# benchmark_graders.ps1
# Graders para o Antigravity Performance Benchmark Suite
# Avalia fixtures de benchmark nas 5 dimensões

function Test-InstructionAdherence {
    param (
        [string]$FixturePath,
        [string]$RepoRoot
    )

    $results = @()
    $rawJson = Get-Content -Path $FixturePath -Raw -Encoding UTF8
    $fixture = $rawJson | ConvertFrom-Json

    foreach ($test in $fixture.tests) {
        $testResult = [PSCustomObject]@{
            TestId    = $test.id
            TestName  = $test.name
            Passed    = $true
            Total     = $test.constraints.Count
            PassedC   = 0
            FailedC   = 0
            Details   = @()
            Severity  = $test.severity
        }

        # Para benchmark de instrução, validamos a EXISTÊNCIA dos constraints
        # (a execução real seria contra output do modelo — aqui validamos o fixture)
        foreach ($constraint in $test.constraints) {
            $valid = $false
            switch ($constraint.type) {
                "contains"           { $valid = ($null -ne $constraint.value -and $constraint.value.Length -gt 0) }
                "contains_ci"        { $valid = ($null -ne $constraint.value -and $constraint.value.Length -gt 0) }
                "not_contains"       { $valid = ($null -ne $constraint.value -and $constraint.value.Length -gt 0) }
                "not_contains_ci"    { $valid = ($null -ne $constraint.value -and $constraint.value.Length -gt 0) }
                "matches"            { $valid = ($null -ne $constraint.value -and $constraint.value.Length -gt 0) }
                "paragraph_count"    { $valid = ($constraint.value -gt 0) }
                "min_sentences_per_paragraph" { $valid = ($constraint.value -gt 0) }
                "min_count"          { $valid = ($null -ne $constraint.value -and $constraint.count -gt 0) }
                Default              { $valid = $false }
            }

            if ($valid) {
                $testResult.PassedC++
                $testResult.Details += "PASS: $($constraint.description)"
            } else {
                $testResult.FailedC++
                $testResult.Passed = $false
                $testResult.Details += "FAIL: $($constraint.description) - invalid constraint definition"
            }
        }

        $results += $testResult
    }

    return $results
}

function Test-CircuitBreakerCompliance {
    param (
        [string]$FixturePath,
        [string]$RepoRoot
    )

    $results = @()
    $rawJson = Get-Content -Path $FixturePath -Raw -Encoding UTF8
    $fixture = $rawJson | ConvertFrom-Json

    foreach ($test in $fixture.tests) {
        $testResult = [PSCustomObject]@{
            TestId    = $test.id
            TestName  = $test.name
            Passed    = $false
            Details   = ""
        }

        # Verify the circuit breaker exists in the referenced file
        $v = $test.verification
        $targetPath = Join-Path $RepoRoot $v.target
        if (-not (Test-Path $targetPath)) {
            $testResult.Details = "Target file not found: $($v.target)"
            $results += $testResult
            continue
        }

        $content = Get-Content -Path $targetPath -Raw -Encoding UTF8

        switch ($v.operator) {
            "contains" {
                if ($content.Contains($v.expected_value)) {
                    $testResult.Passed = $true
                    $testResult.Details = "Circuit breaker rule confirmed: '$($v.expected_value)' found in $($v.target)"
                } else {
                    $testResult.Details = "Circuit breaker rule MISSING: '$($v.expected_value)' not found in $($v.target)"
                }
            }
            "matches" {
                if ($content -match $v.expected_value) {
                    $testResult.Passed = $true
                    $testResult.Details = "Circuit breaker pattern confirmed in $($v.target)"
                } else {
                    $testResult.Details = "Circuit breaker pattern MISSING in $($v.target)"
                }
            }
        }

        $results += $testResult
    }

    return $results
}

function Test-ReasoningQualityFixtures {
    param (
        [string]$FixturePath
    )

    $results = @()
    $rawJson = Get-Content -Path $FixturePath -Raw -Encoding UTF8
    $fixture = $rawJson | ConvertFrom-Json

    foreach ($test in $fixture.tests) {
        $testResult = [PSCustomObject]@{
            TestId     = $test.id
            TestName   = $test.name
            Difficulty = $test.difficulty
            Passed     = $true
            Details    = ""
        }

        # Validate fixture structure (the actual reasoning test requires model execution)
        $hasPrompt = ($null -ne $test.prompt -and $test.prompt.Length -gt 50)
        $hasSolution = ($null -ne $test.expected_solution.must_contain -and $test.expected_solution.must_contain.Count -gt 0)
        $hasTargets = ($null -ne $test.efficiency_targets.max_tool_calls -and $test.efficiency_targets.max_tool_calls -gt 0)

        if (-not $hasPrompt) {
            $testResult.Passed = $false
            $testResult.Details = "Missing or too short prompt"
        } elseif (-not $hasSolution) {
            $testResult.Passed = $false
            $testResult.Details = "Missing expected solution criteria"
        } elseif (-not $hasTargets) {
            $testResult.Passed = $false
            $testResult.Details = "Missing efficiency targets"
        } else {
            $testResult.Details = "Fixture valid: difficulty=$($test.difficulty), max_tools=$($test.efficiency_targets.max_tool_calls), expected_keywords=$($test.expected_solution.must_contain.Count)"
        }

        $results += $testResult
    }

    return $results
}

function Test-ContextBudget {
    param (
        [string]$FixturePath,
        [string]$RepoRoot,
        [string]$Profile = "current"
    )

    $results = @()
    $rawJson = Get-Content -Path $FixturePath -Raw -Encoding UTF8
    $fixture = $rawJson | ConvertFrom-Json

    $profileData = $fixture.profiles.$Profile
    if (-not $profileData) {
        return @([PSCustomObject]@{
            TestId = "CB-ERR"; TestName = "Profile not found"; Passed = $false; Details = "Profile '$Profile' not found"
        })
    }

    $measurements = $profileData.measurements

    # Live measurement: count ia.md actual state
    $iaPath = Join-Path $RepoRoot ".agent/rules/ia.md"
    $iaExists = Test-Path $iaPath
    $iaChars = 0
    if ($iaExists) {
        $iaContent = Get-Content -Path $iaPath -Raw -Encoding UTF8
        $iaChars = $iaContent.Length
    }

    # Live measurement: count SKILL.md files
    $skillDir = Join-Path $RepoRoot "skills"
    $skillFiles = @()
    $skillTotalChars = 0
    if (Test-Path $skillDir) {
        $skillFiles = Get-ChildItem -Recurse -Path $skillDir -Filter "SKILL.md" -ErrorAction SilentlyContinue
        foreach ($sf in $skillFiles) {
            $sc = Get-Content $sf.FullName -Raw -ErrorAction SilentlyContinue
            if ($sc) { $skillTotalChars += $sc.Length }
        }
    }

    $liveTokensIa = [math]::Round($iaChars / 4)
    $liveTokensSkills = [math]::Round($skillTotalChars / 4)
    $liveFixedOverhead = 8000 + $liveTokensIa + 2500  # platform + ia.md + catalog summary
    $liveFixedPct = [math]::Round(($liveFixedOverhead / 200000) * 100, 2)

    $results += [PSCustomObject]@{
        TestId   = "CTX-001"
        TestName = "Live: ia.md token count"
        Passed   = ($liveTokensIa -lt 3000)
        Details  = "ia.md: $iaChars chars (~$liveTokensIa tokens). Target: under 3000 tokens for single copy."
    }

    $results += [PSCustomObject]@{
        TestId   = "CTX-002"
        TestName = "Live: SKILL.md total budget"
        Passed   = ($liveTokensSkills -lt 35000)
        Details  = "$($skillFiles.Count) SKILL.md files: $skillTotalChars chars (~$liveTokensSkills tokens). Target: under 35000."
    }

    $results += [PSCustomObject]@{
        TestId   = "CTX-003"
        TestName = "Live: Fixed overhead under 10pct context window"
        Passed   = ($liveFixedPct -lt 10)
        Details  = "Fixed overhead: ~$liveFixedOverhead tokens ($($liveFixedPct) pct of 200k). Target: under 10 pct."
    }

    # Threshold checks from fixture
    foreach ($assertion in $fixture.assertions) {
        $fieldValue = $measurements.($assertion.field)
        $passed = $false
        switch ($assertion.check_type) {
            "value_equals" { $passed = ($fieldValue -eq $assertion.expected_value) }
            "value_lt"     { $passed = ($fieldValue -lt $assertion.expected_value) }
            "value_gt"     { $passed = ($fieldValue -gt $assertion.expected_value) }
        }

        $results += [PSCustomObject]@{
            TestId   = "CTX-THR"
            TestName = "Threshold ($Profile): $($assertion.name)"
            Passed   = $passed
            Details  = "Field $($assertion.field) = $fieldValue (expected: $($assertion.check_type) $($assertion.expected_value)). Severity: $($assertion.severity)"
        }
    }

    return $results
}

function Get-BenchmarkSummary {
    param (
        [array]$AllResults
    )

    $total = $AllResults.Count
    $passed = ($AllResults | Where-Object { $_.Passed -eq $true }).Count
    $failed = $total - $passed
    $passRate = if ($total -gt 0) { [math]::Round(($passed / $total) * 100, 2) } else { 0 }

    return [PSCustomObject]@{
        TotalTests = $total
        Passed     = $passed
        Failed     = $failed
        PassRate   = $passRate
        Status     = if ($failed -eq 0) { "BENCHMARK_PASSED" } else { "BENCHMARK_DEGRADED" }
    }
}
