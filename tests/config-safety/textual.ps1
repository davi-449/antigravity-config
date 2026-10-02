[CmdletBinding()]
param()

$ErrorActionPreference = 'Stop'
$root = Split-Path -Parent (Split-Path -Parent $PSScriptRoot)
$checks = @(
    @{ file='.agent/rules/ia.md'; pattern='para o usu.rio, escreva em portugu.s simples'; reason='human output rule' },
    @{ file='.agent/rules/ia.md'; pattern='sdd-reviewer'; reason='optional reviewer routing' },
    @{ file='skills/sdd-proposal/SKILL.md'; pattern='uma linha de evid.ncia basta'; reason='proportional existing code evidence' },
    @{ file='skills/sdd-apply/SKILL.md'; pattern='git diff --cached --binary'; reason='initial index baseline' },
    @{ file='skills/sdd-archive/SKILL.md'; pattern='Exclua esses caminhos do staging'; reason='preserve unknown artifacts' },
    @{ file='skills/sdd-debug/SKILL.md'; pattern='git reset --hard.*automaticamente'; reason='no destructive automatic rollback' },
    @{ file='.agents/agents/sdd-reviewer.md'; pattern='commandExecutionPolicy: off'; reason='reviewer cannot run commands' }
)
$failures = [Collections.Generic.List[string]]::new()
foreach ($check in $checks) {
    $content = Get-Content -LiteralPath (Join-Path $root $check.file) -Raw -Encoding UTF8
    if ($content -notmatch $check.pattern) { $failures.Add("$($check.reason): $($check.file)") }
}
[PSCustomObject]@{
    evidence_level='rule_text_only'
    passed=$checks.Count - $failures.Count
    total=$checks.Count
    failures=@($failures)
} | ConvertTo-Json -Depth 4
if ($failures.Count) { exit 1 }
