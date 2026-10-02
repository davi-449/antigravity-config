# Prepares disposable repositories for Antigravity 2.0 and verifies its transcript and final state.
# The agent must be run in the Antigravity 2.0 app between Prepare and Verify.
[CmdletBinding()]
param(
    [ValidateSet('Prepare', 'Verify')][string]$Mode = 'Prepare',
    [string]$CaseId = "",
    [string]$WorkspacePath = "",
    [string]$TranscriptPath = "",
    [string]$ReportPath = ""
)

$ErrorActionPreference = "Stop"
$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$repoRoot = Split-Path -Parent $scriptDir
$scenarioPath = Join-Path $repoRoot "tests/eval-harness/scenarios/sdd-preservation.json"
$scenarioSet = Get-Content -LiteralPath $scenarioPath -Raw -Encoding UTF8 | ConvertFrom-Json
$cases = @($scenarioSet.cases | Where-Object { -not $CaseId -or $_.id -eq $CaseId })
if ($cases.Count -eq 0) { throw "No behavior scenario matched CaseId '$CaseId'." }
if ($Mode -eq 'Verify' -and ($cases.Count -ne 1 -or -not $WorkspacePath)) {
    throw 'Verify requires one CaseId and its prepared WorkspacePath.'
}

function Write-FixtureFiles {
    param([string]$Root, [object]$Files)
    if (-not $Files) { return }
    foreach ($entry in $Files.PSObject.Properties) {
        $relative = $entry.Name.Replace('/', [IO.Path]::DirectorySeparatorChar)
        $path = [IO.Path]::GetFullPath((Join-Path $Root $relative))
        $prefix = [IO.Path]::GetFullPath($Root).TrimEnd([IO.Path]::DirectorySeparatorChar) + [IO.Path]::DirectorySeparatorChar
        if (-not $path.StartsWith($prefix, [StringComparison]::OrdinalIgnoreCase)) { throw "Unsafe fixture path: $relative" }
        $parent = Split-Path -Parent $path
        New-Item -ItemType Directory -Path $parent -Force | Out-Null
        [IO.File]::WriteAllText($path, [string]$entry.Value, [Text.UTF8Encoding]::new($false))
    }
}

function Git-Text {
    param([string]$Root, [string[]]$GitArgs)
    $output = & git -C $Root @GitArgs 2>&1
    if ($LASTEXITCODE -ne 0) { throw "git $($GitArgs -join ' ') failed in fixture: $($output -join ' ')" }
    return ($output -join "`n")
}

function File-Digest {
    param([string]$Root, [string]$Relative)
    $path = Join-Path $Root $Relative
    if (-not (Test-Path -LiteralPath $path -PathType Leaf)) { return "<absent>" }
    return (Get-FileHash -LiteralPath $path -Algorithm SHA256).Hash
}

function Get-ToolTrace {
    param([string]$TracePath)
    $parts = [Collections.Generic.List[string]]::new()
    $denials = [Collections.Generic.List[string]]::new()
    $lastEvent = $null
    foreach ($line in (Get-Content -LiteralPath $TracePath -ErrorAction SilentlyContinue)) {
        if (-not $line.TrimStart().StartsWith('{')) { continue }
        try { $event = $line | ConvertFrom-Json -ErrorAction Stop } catch { continue }
        $lastEvent = $event
        if ($event.event -eq 'step_update' -and $event.step_update.step_type -eq 'tool') {
            $parts.Add(($event.step_update | ConvertTo-Json -Depth 30 -Compress))
            $toolError = [string]$event.step_update.tool_info.error.message
            if ($toolError -match '(?i)permission check failed|denied permission') {
                $denials.Add("Tool permission denied: $($event.step_update.tool_name)")
            }
        }
        if ($event.event -eq 'result' -and $event.result.denied_actions) {
            $denials.Add('AGY result contains denied_actions.')
        }
        $type = [string]$event.type
        if ($type -match '(?i)tool|function') { $parts.Add(($event | ConvertTo-Json -Depth 30 -Compress)) }
        foreach ($field in @('tool_calls', 'toolCalls', 'tool_use', 'toolUse', 'toolCall', 'functionCall')) {
            if ($event.PSObject.Properties.Name -contains $field) {
                $parts.Add(($event.$field | ConvertTo-Json -Depth 30 -Compress))
            }
        }
        if ($event.message) {
            $message = $event.message
            if ($message.tool_calls -or $message.toolCalls -or $message.tool_use -or $message.toolUse) {
                $parts.Add(($message | ConvertTo-Json -Depth 30 -Compress))
            }
            foreach ($item in @($message.content)) {
                if ($item -and [string]$item.type -match '(?i)tool|function') {
                    $parts.Add(($item | ConvertTo-Json -Depth 30 -Compress))
                }
            }
        }
        if ($event.toolCall -or $event.toolResult) {
            $parts.Add(($event | ConvertTo-Json -Depth 30 -Compress))
        }
    }
    $finished = $lastEvent -and $lastEvent.source -eq 'MODEL' -and
        $lastEvent.type -eq 'PLANNER_RESPONSE' -and $lastEvent.status -eq 'DONE' -and
        -not [string]::IsNullOrWhiteSpace([string]$lastEvent.content)
    return [PSCustomObject]@{ Text=($parts -join "`n"); Denials=@($denials); Finished=[bool]$finished; FinalText=$(if ($finished) { [string]$lastEvent.content } else { '' }) }
}

$results = [Collections.Generic.List[object]]::new()
foreach ($case in $cases) {
    $caseRoot = if ($Mode -eq 'Prepare') {
        Join-Path ([IO.Path]::GetTempPath()) ("agy2-sdd-eval-" + [guid]::NewGuid().ToString('N'))
    } else { Split-Path -Parent ([IO.Path]::GetFullPath($WorkspacePath)) }
    $workRoot = Join-Path $caseRoot 'work'
    $baselinePath = Join-Path $caseRoot 'baseline.json'
    $problems = [Collections.Generic.List[string]]::new()

    try {
        if ($Mode -eq 'Verify') {
            $expectedRoot = [IO.Path]::GetFullPath((Join-Path ([IO.Path]::GetTempPath()) 'agy2-sdd-eval-'))
            if (-not ([IO.Path]::GetFullPath($caseRoot)).StartsWith($expectedRoot, [StringComparison]::OrdinalIgnoreCase)) {
                throw 'Workspace is not an AGY 2.0 disposable fixture.'
            }
            if (-not (Test-Path -LiteralPath $baselinePath -PathType Leaf)) { throw 'Prepared baseline is absent.' }
            $baseline = Get-Content -LiteralPath $baselinePath -Raw -Encoding UTF8 | ConvertFrom-Json
            if ($baseline.case_id -ne $case.id) { throw 'CaseId does not match the prepared baseline.' }
            if (-not $TranscriptPath -or -not (Test-Path -LiteralPath $TranscriptPath -PathType Leaf)) {
                throw 'Antigravity 2.0 transcript absent; behavioral result is NAO_VERIFICADO.'
            }
            $brainRoot = [IO.Path]::GetFullPath((Join-Path $env:USERPROFILE '.gemini/antigravity/brain'))
            $resolvedTranscript = [IO.Path]::GetFullPath($TranscriptPath)
            if (-not $resolvedTranscript.StartsWith($brainRoot + [IO.Path]::DirectorySeparatorChar, [StringComparison]::OrdinalIgnoreCase) -or
                [IO.Path]::GetFileName($resolvedTranscript) -ne 'transcript.jsonl') {
                throw 'Transcript must be an Antigravity 2.0 brain transcript.jsonl.'
            }
            if ((Get-Item -LiteralPath $resolvedTranscript).LastWriteTimeUtc -lt [datetime]$baseline.prepared_utc) {
                throw 'Transcript predates fixture preparation.'
            }
            $rawTrace = Get-Content -LiteralPath $resolvedTranscript -Raw -Encoding UTF8
            if ($rawTrace -notmatch [regex]::Escape([string]$baseline.run_marker)) {
                throw 'Transcript does not contain this fixture run marker.'
            }
            $traceEvidence = Get-ToolTrace -TracePath $resolvedTranscript
            $toolTrace = $traceEvidence.Text
            $blocked = @($traceEvidence.Denials).Count -gt 0
            $headBefore = [string]$baseline.head_before
            $indexBefore = [string]$baseline.index_before
            $diffBefore = [string]$baseline.diff_before
            $protectedBefore = @{}
            foreach ($item in $baseline.protected_before.PSObject.Properties) { $protectedBefore[$item.Name] = [string]$item.Value }
        } else {
        New-Item -ItemType Directory -Path $workRoot -Force | Out-Null
        # Give the agent the current skill under test in its workspace, not the installed global copy.
        $skillName = "sdd-$($case.phase)"
        $workspaceSkill = Join-Path $workRoot ".agents/skills/$skillName"
        New-Item -ItemType Directory -Path (Split-Path -Parent $workspaceSkill) -Force | Out-Null
        Copy-Item -LiteralPath (Join-Path $repoRoot "skills/$skillName") -Destination $workspaceSkill -Recurse
        $canonicalSkill = Join-Path $workRoot "skills/$skillName"
        New-Item -ItemType Directory -Path (Split-Path -Parent $canonicalSkill) -Force | Out-Null
        Copy-Item -LiteralPath (Join-Path $repoRoot "skills/$skillName") -Destination $canonicalSkill -Recurse
        $ruleDir = Join-Path $workRoot '.agent/rules'
        New-Item -ItemType Directory -Path $ruleDir -Force | Out-Null
        Copy-Item -LiteralPath (Join-Path $repoRoot '.agent/rules/ia.md') -Destination (Join-Path $ruleDir 'ia.md')
        $reviewerDir = Join-Path $workRoot '.agents/agents'
        New-Item -ItemType Directory -Path $reviewerDir -Force | Out-Null
        Copy-Item -LiteralPath (Join-Path $repoRoot '.agents/agents/sdd-reviewer.md') -Destination (Join-Path $reviewerDir 'sdd-reviewer.md')
        if ($case.phase -eq 'archive') {
            $securityDir = Join-Path $workRoot 'scripts'
            New-Item -ItemType Directory -Path $securityDir -Force | Out-Null
            Copy-Item -LiteralPath (Join-Path $repoRoot 'scripts/security-audit.ps1') -Destination (Join-Path $securityDir 'security-audit.ps1')
            $obsidianDir = Join-Path $workRoot 'skills/obsidian'
            Copy-Item -LiteralPath (Join-Path $repoRoot 'skills/obsidian') -Destination $obsidianDir -Recurse
        }
        Write-FixtureFiles -Root $workRoot -Files $case.seed_files

        Git-Text -Root $workRoot -GitArgs @('init', '--quiet') | Out-Null
        Git-Text -Root $workRoot -GitArgs @('config', 'core.autocrlf', 'false') | Out-Null
        Git-Text -Root $workRoot -GitArgs @('add', '--all') | Out-Null
        Git-Text -Root $workRoot -GitArgs @('-c', 'user.name=Fixture', '-c', 'user.email=fixture@example.invalid', 'commit', '--quiet', '-m', 'fixture baseline') | Out-Null
        # These commits exist only inside disposable fixture repositories.
        Write-FixtureFiles -Root $workRoot -Files $case.preexisting_unstaged
        Write-FixtureFiles -Root $workRoot -Files $case.preexisting_staged
        if ($case.preexisting_staged) {
            foreach ($entry in $case.preexisting_staged.PSObject.Properties) {
                Git-Text -Root $workRoot -GitArgs @('add', '--', $entry.Name) | Out-Null
            }
        }
        $headBefore = Git-Text -Root $workRoot -GitArgs @('rev-parse', 'HEAD')
        $indexBefore = Git-Text -Root $workRoot -GitArgs @('diff', '--cached', '--binary')
        $diffBefore = Git-Text -Root $workRoot -GitArgs @('diff', '--binary')
        $protectedBefore = @{}
        foreach ($path in @($case.expect.protected_paths)) { $protectedBefore[$path] = File-Digest -Root $workRoot -Relative $path }
        $runMarker = 'agy2-eval-' + [guid]::NewGuid().ToString('N')
        [PSCustomObject]@{
            case_id=$case.id; run_marker=$runMarker; prepared_utc=[datetime]::UtcNow.ToString('o')
            head_before=$headBefore; index_before=$indexBefore; diff_before=$diffBefore
            protected_before=$protectedBefore
        } | ConvertTo-Json -Depth 8 | Set-Content -LiteralPath $baselinePath -Encoding utf8
        $results.Add([PSCustomObject]@{
            id=$case.id; kind=$case.kind; status='PREPARADO'; workspace=$workRoot
            prompt="$($case.prompt) Identificador deste ensaio: $runMarker. Este repositorio e descartavel; nao altere configuracoes globais do Git. Se necessario, use git -c safe.directory=<workspace> em cada comando."
            instruction='Abra este workspace no Antigravity 2.0, execute o prompt e passe o transcript.jsonl da conversa ao modo Verify.'
        })
        continue
        }
        $status = 'PASSOU'
        if ([string]::IsNullOrWhiteSpace($toolTrace) -or $blocked -or -not $traceEvidence.Finished) {
            $status = 'NAO_VERIFICADO'
            $problems.Add("Recognizable tool trace=$(-not [string]::IsNullOrWhiteSpace($toolTrace)); final model response=$($traceEvidence.Finished); permission denied=$blocked.")
            foreach ($denial in $traceEvidence.Denials) { $problems.Add($denial) }
        }
        foreach ($pattern in @($case.expect.required_trace)) {
            if ($toolTrace -notmatch [string]$pattern) {
                if ($status -ne 'FALHOU') { $status = 'NAO_VERIFICADO' }
                $problems.Add("Tool trace lacks required action: $pattern")
            }
        }
        foreach ($pattern in @($case.expect.forbidden_trace | Where-Object { $_ })) {
            if ($toolTrace -match [string]$pattern) {
                $status = 'FALHOU'; $problems.Add("Forbidden action in tool trace: $pattern")
            }
        }
        foreach ($pattern in @($case.expect.required_final | Where-Object { $_ })) {
            if ($traceEvidence.Finished -and $traceEvidence.FinalText -notmatch [string]$pattern) {
                $status = 'FALHOU'; $problems.Add("Final response lacks expected explanation: $pattern")
            }
        }
        foreach ($path in @($case.expect.protected_paths)) {
            if ((File-Digest -Root $workRoot -Relative $path) -ne $protectedBefore[$path]) {
                $status = 'FALHOU'; $problems.Add("Protected file changed: $path")
            }
        }
        foreach ($path in @($case.expect.must_exist)) {
            if (-not (Test-Path -LiteralPath (Join-Path $workRoot $path))) {
                if (-not $blocked -and $status -eq 'PASSOU') { $status = 'FALHOU' }
                $problems.Add("Expected path absent: $path")
            }
        }
        foreach ($path in @($case.expect.must_not_exist)) {
            if (Test-Path -LiteralPath (Join-Path $workRoot $path)) {
                $status = 'FALHOU'; $problems.Add("Unexpected path exists: $path")
            }
        }
        foreach ($match in @($case.expect.must_match)) {
            $path = Join-Path $workRoot $match.path
            if (-not (Test-Path -LiteralPath $path) -or ((Get-Content -LiteralPath $path -Raw) -notmatch [string]$match.pattern)) {
                if (-not $blocked -and $status -eq 'PASSOU') { $status = 'FALHOU' }
                $problems.Add("Expected content absent: $($match.path): $($match.pattern)")
            }
        }
        if ($case.expect.index_unchanged -and (Git-Text -Root $workRoot -GitArgs @('diff', '--cached', '--binary')) -ne $indexBefore) {
            $status = 'FALHOU'; $problems.Add('Preexisting staged diff changed.')
        }
        if ($case.expect.worktree_diff_unchanged -and (Git-Text -Root $workRoot -GitArgs @('diff', '--binary')) -ne $diffBefore) {
            $status = 'FALHOU'; $problems.Add('Preexisting unstaged diff changed.')
        }
        if ($case.expect.head_unchanged -and (Git-Text -Root $workRoot -GitArgs @('rev-parse', 'HEAD')) -ne $headBefore) {
            $status = 'FALHOU'; $problems.Add('Unexpected fixture commit.')
        }
        if ($case.expect.allowed_changes) {
            $changed = @((Git-Text -Root $workRoot -GitArgs @('diff', '--name-only', 'HEAD')) -split "`n" | Where-Object { $_ })
            $changed += @((Git-Text -Root $workRoot -GitArgs @('ls-files', '--others', '--exclude-standard')) -split "`n" | Where-Object { $_ })
            foreach ($path in $changed) {
                if (-not @($case.expect.allowed_changes | Where-Object { $path -match $_ }).Count) {
                    $status = 'FALHOU'; $problems.Add("Unexpected changed path: $path")
                }
            }
        }
        if ($case.expect.allowed_staged) {
            $staged = @((Git-Text -Root $workRoot -GitArgs @('diff', '--cached', '--name-only')) -split "`n" | Where-Object { $_ })
            foreach ($path in $staged) {
                if (-not @($case.expect.allowed_staged | Where-Object { $path -match $_ }).Count) {
                    $status = 'FALHOU'; $problems.Add("Unexpected staged path: $path")
                }
            }
            if ($case.expect.min_staged_paths -and $staged.Count -lt [int]$case.expect.min_staged_paths) {
                if (-not $blocked -and $status -eq 'PASSOU') { $status = 'FALHOU' }
                $problems.Add("Expected at least $($case.expect.min_staged_paths) staged paths; found $($staged.Count).")
            }
        }
        $results.Add([PSCustomObject]@{ id=$case.id; kind=$case.kind; status=$status; problems=@($problems); workspace=$workRoot; trace=$resolvedTranscript })
    } catch {
        $results.Add([PSCustomObject]@{ id=$case.id; kind=$case.kind; status='NAO_VERIFICADO'; problems=@([string]$_); workspace=$workRoot; trace=$TranscriptPath })
    }
}

$report = [PSCustomObject]@{ surface='Antigravity 2.0'; evidence_level=$(if ($Mode -eq 'Prepare') { 'fixture_only' } else { 'agy2_transcript_and_final_state' }); cases=@($results) }
if ($ReportPath) {
    $report | ConvertTo-Json -Depth 12 | Set-Content -LiteralPath $ReportPath -Encoding utf8
}
$report | ConvertTo-Json -Depth 12
if (@($results | Where-Object status -eq 'FALHOU').Count -gt 0) { exit 1 }
if (@($results | Where-Object status -eq 'NAO_VERIFICADO').Count -gt 0) { exit 2 }
exit 0
