[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$repoRoot = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$caseRoot = Join-Path ([IO.Path]::GetTempPath()) ('agy-config-safety-' + [guid]::NewGuid().ToString('N'))
$globalRoot = Join-Path $caseRoot 'global'
$scratchRoot = Join-Path $caseRoot 'scratch'
$projectRoot = Join-Path $scratchRoot 'fixture'
New-Item -ItemType Directory -Path (Join-Path $globalRoot 'skills/backend-patterns') -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $globalRoot 'skills/foreign') -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $globalRoot 'skills/sdd-apply') -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $projectRoot '.council') -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $projectRoot '.agent/agents/workers') -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $projectRoot 'skills/backend-patterns') -Force | Out-Null
New-Item -ItemType Directory -Path (Join-Path $projectRoot 'skills/sdd-apply') -Force | Out-Null

function Export-GitBlob {
    param([string]$Root, [string]$Rev, [string]$Destination)
    $blobId = ((& git -C $Root rev-parse $Rev) -join '').Trim()
    if ($LASTEXITCODE -ne 0 -or -not $blobId) { throw "Could not resolve revision '$Rev'" }
    $dir = Split-Path -Parent $Destination
    if (-not (Test-Path $dir)) { New-Item -ItemType Directory -Path $dir -Force | Out-Null }
    $proc = Start-Process git -ArgumentList "-C `"$Root`" cat-file -p $blobId" -NoNewWindow -RedirectStandardOutput $Destination -PassThru
    $proc.WaitForExit()
}

Export-GitBlob -Root $repoRoot -Rev 'HEAD^:skills/sdd-apply/SKILL.md' -Destination (Join-Path $globalRoot 'skills/sdd-apply/SKILL.md')
Export-GitBlob -Root $repoRoot -Rev 'HEAD^:skills/sdd-apply/SKILL.md' -Destination (Join-Path $projectRoot 'skills/sdd-apply/SKILL.md')
Export-GitBlob -Root $repoRoot -Rev 'HEAD:.agent/rules/ia.md' -Destination (Join-Path $projectRoot '.agent/rules/ia.md')


$sentinels = @{
    (Join-Path $globalRoot 'AGENTS.md') = 'global user rule'
    (Join-Path $globalRoot 'skills/backend-patterns/SKILL.md') = 'global custom skill'
    (Join-Path $globalRoot 'skills/foreign/SKILL.md') = 'foreign skill'
    (Join-Path $projectRoot 'AGENTS.md') = 'project user rule'
    (Join-Path $projectRoot 'GEMINI.md') = 'project user gemini rule'
    (Join-Path $projectRoot '.council/user.txt') = 'project council data'
    (Join-Path $projectRoot '.agent/agents/workers/custom.md') = 'project worker data'
    (Join-Path $projectRoot 'skills/backend-patterns/SKILL.md') = 'project custom skill'
}
foreach ($path in $sentinels.Keys) { [IO.File]::WriteAllText($path, $sentinels[$path]) }

$errors = [Collections.Generic.List[string]]::new()
$priorRuleHash = (Get-FileHash -LiteralPath (Join-Path $projectRoot '.agent/rules/ia.md')).Hash
& (Join-Path $repoRoot 'scripts/sync-global.ps1') -GlobalConfigPath $globalRoot -DryRun *> (Join-Path $caseRoot 'sync-dry.log')
& (Join-Path $repoRoot 'scripts/deploy-to-projects.ps1') -ScratchPath $scratchRoot -ProjectName fixture -DryRun *> (Join-Path $caseRoot 'deploy-dry.log')
if (Test-Path -LiteralPath (Join-Path $globalRoot 'skills/sdd-proposal/SKILL.md')) { $errors.Add('Global dry run copied a skill.') }
if (Test-Path -LiteralPath (Join-Path $projectRoot 'skills/sdd-proposal/SKILL.md')) { $errors.Add('Project dry run copied a skill.') }
if ((Get-FileHash -LiteralPath (Join-Path $projectRoot '.agent/rules/ia.md')).Hash -ne $priorRuleHash) { $errors.Add('Project dry run updated the rule.') }

& (Join-Path $repoRoot 'scripts/sync-global.ps1') -GlobalConfigPath $globalRoot *> (Join-Path $caseRoot 'sync.log')
$syncExit = $LASTEXITCODE
& (Join-Path $repoRoot 'scripts/deploy-to-projects.ps1') -ScratchPath $scratchRoot -ProjectName fixture *> (Join-Path $caseRoot 'deploy.log')
$deployExit = $LASTEXITCODE
foreach ($path in $sentinels.Keys) {
    if (-not (Test-Path -LiteralPath $path) -or [IO.File]::ReadAllText($path) -ne $sentinels[$path]) {
        $errors.Add("Preexisting file changed: $path")
    }
}
if (-not (Test-Path -LiteralPath (Join-Path $globalRoot 'skills/sdd-proposal/SKILL.md'))) { $errors.Add('Global skill was not copied.') }
if (-not (Test-Path -LiteralPath (Join-Path $projectRoot 'skills/sdd-proposal/SKILL.md'))) { $errors.Add('Project skill was not copied.') }
foreach ($root in @($globalRoot, $projectRoot)) {
    $updated = Join-Path $root 'skills/sdd-apply/SKILL.md'
    if ((Get-FileHash -LiteralPath $updated).Hash -ne (Get-FileHash -LiteralPath (Join-Path $repoRoot 'skills/sdd-apply/SKILL.md')).Hash) {
        $errors.Add("Verified prior skill was not updated: $updated")
    }
}
if (-not (Test-Path -LiteralPath (Join-Path $globalRoot 'agents/sdd-reviewer.md'))) { $errors.Add('AGY 2.0 reviewer was not installed at agents/sdd-reviewer.md.') }
if ((Get-FileHash -LiteralPath (Join-Path $projectRoot '.agent/rules/ia.md')).Hash -ne (Get-FileHash -LiteralPath (Join-Path $repoRoot '.agent/rules/ia.md')).Hash) {
    $errors.Add('Verified prior local rule was not updated.')
}
if ($syncExit -eq 0) { $errors.Add('Global conflict should produce a nonzero exit code.') }
if ($deployExit -eq 0) { $errors.Add('Project conflict should produce a nonzero exit code.') }

[PSCustomObject]@{ status=$(if ($errors.Count) { 'FALHOU' } else { 'PASSOU' }); errors=@($errors); fixture=$caseRoot } | ConvertTo-Json -Depth 4
if ($errors.Count) { exit 1 }
