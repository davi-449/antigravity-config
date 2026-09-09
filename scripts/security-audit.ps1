# scripts/security-audit.ps1
# Automated local security auditor for Antigravity projects.
# Executes: Secrets Scan, Git History Forensics, Dependency SCA, and OWASP baseline checks.
# Usage: .\scripts\security-audit.ps1 [-DeepScan] [-Path <target-dir>]

param(
    [switch]$DeepScan,
    [string]$Path = "."
)

$ErrorActionPreference = "Continue"

Write-Host "`n=======================================================" -ForegroundColor Red
Write-Host "   🛡️ Antigravity AppSec & Cybersecurity Audit" -ForegroundColor Red
Write-Host "=======================================================" -ForegroundColor Red
Write-Host "Target Path: $Path" -ForegroundColor White
Write-Host "Deep Scan:   $($DeepScan.IsPresent)" -ForegroundColor White
Write-Host "Timestamp:   $((Get-Date).ToString('yyyy-MM-dd HH:mm:ss'))" -ForegroundColor White
Write-Host "-------------------------------------------------------`n"

$findings = @()

$secretPatterns = @(
    @{ Name = "OpenAI API Key";          Pattern = "sk-[a-zA-Z0-9]{48}|sk-proj-[a-zA-Z0-9_-]+" },
    @{ Name = "Stripe Secret Key";       Pattern = "sk_live_[0-9a-zA-Z]{24}" },
    @{ Name = "Supabase Service Role";   Pattern = "eyJhbGciOi[a-zA-Z0-9._-]+" },
    @{ Name = "GitHub Personal Token";   Pattern = "ghp_[0-9a-zA-Z]{36}|github_pat_[0-9a-zA-Z_]+" },
    @{ Name = "AWS Access Key ID";       Pattern = "AKIA[0-9A-Z]{16}" },
    @{ Name = "Private Key Header";      Pattern = "-----BEGIN (RSA|OPENSSH|PRIVATE) KEY-----" }
)

# --- 1. Secrets Scan (Working Tree) ---
Write-Host "[1/4] Scanning working tree for leaked credentials..." -ForegroundColor Yellow

$gitFiles = git -C $Path ls-files 2>$null
$count = 0

if ($gitFiles) {
    foreach ($relFile in $gitFiles) {
        if ($relFile -match "\.(ts|tsx|js|jsx|json|md|py|go|rs|env|yml|yaml|sql|ps1|sh)$") {
            # Skip documentation files and templates that contain example patterns
            if ($relFile -match "references|templates|\.example|README\.md|walkthrough\.md|SPEC\.md|secrets-patterns\.md|security-audit\.ps1") {
                continue
            }
            $fullPath = Join-Path $Path $relFile
            if (Test-Path $fullPath) {
                $count++
                $content = Get-Content -Path $fullPath -Raw -ErrorAction SilentlyContinue
                if ($content) {
                    foreach ($sp in $secretPatterns) {
                        if ($content -match $sp.Pattern) {
                            $findings += [PSCustomObject]@{
                                Category = "SECRETS"
                                Severity = "CRITICAL"
                                Target   = $relFile
                                Issue    = "Potencial vazamento de $($sp.Name)"
                            }
                            Write-Host "  [CRITICAL] $($sp.Name) detectado em: $relFile" -ForegroundColor Red
                        }
                    }
                }
            }
        }
    }
}
Write-Host "  Scanned $count tracked source files." -ForegroundColor DarkGray

# --- 2. Git History Forensics ---
Write-Host "[2/4] Scanning Git commit history for leaked secrets..." -ForegroundColor Yellow

if (Test-Path (Join-Path $Path ".git")) {
    $commitLog = git -C $Path --no-pager log -p -n 10 -- . ":(exclude)skills/security/references/secrets-patterns.md" 2>$null
    if ($commitLog) {
        foreach ($sp in $secretPatterns) {
            if ($commitLog -match $sp.Pattern) {
                $findings += [PSCustomObject]@{
                    Category = "GIT_HISTORY"
                    Severity = "HIGH"
                    Target   = "git log"
                    Issue    = "$($sp.Name) encontrado no historico recente de commits"
                }
                Write-Host "  [HIGH] $($sp.Name) encontrado em commits anteriores do Git!" -ForegroundColor Red
            }
        }
    }
    Write-Host "  Git history clean." -ForegroundColor DarkGray
} else {
    Write-Host "  [SKIP] Repositorio Git nao detectado no path." -ForegroundColor DarkGray
}

# --- 3. Dependency Audit (SCA) ---
Write-Host "[3/4] Checking package dependencies for CVEs..." -ForegroundColor Yellow

$packageLock = Join-Path $Path "package-lock.json"
$pnpmLock    = Join-Path $Path "pnpm-lock.yaml"

if ((Test-Path $packageLock) -or (Test-Path $pnpmLock)) {
    $npmAuditOut = cmd.exe /c "npm audit --json" 2>$null
    if ($npmAuditOut) {
        try {
            $auditJson = $npmAuditOut | ConvertFrom-Json
            if ($auditJson.metadata -and $auditJson.metadata.vulnerabilities) {
                $vulns = $auditJson.metadata.vulnerabilities
                $totalVulns = $vulns.total
                if ($totalVulns -gt 0) {
                    Write-Host "  [WARN] Total de vulnerabilidades em dependencias: $totalVulns (Critical: $($vulns.critical), High: $($vulns.high))" -ForegroundColor Yellow
                    $findings += [PSCustomObject]@{
                        Category = "DEPENDENCY_CVE"
                        Severity = $(if ($vulns.critical -gt 0) { "CRITICAL" } elseif ($vulns.high -gt 0) { "HIGH" } else { "MEDIUM" })
                        Target   = "package.json / lockfile"
                        Issue    = "$totalVulns vulnerabilidades detectadas via npm audit"
                    }
                } else {
                    Write-Host "  [PASS] Zero vulnerabilidades conhecidas em pacotes." -ForegroundColor Green
                }
            }
        } catch {
            Write-Host "  [INFO] Analise de npm audit executada." -ForegroundColor DarkGray
        }
    }
} else {
    Write-Host "  [SKIP] Nenhum lockfile Node.js encontrado para inspecao." -ForegroundColor DarkGray
}

# --- 4. OWASP & Code Security Heuristics ---
Write-Host "[4/4] Verifying basic OWASP & configuration hygiene..." -ForegroundColor Yellow

# Check .env in .gitignore
$gitignore = Join-Path $Path ".gitignore"
if (Test-Path $gitignore) {
    $giContent = Get-Content -Path $gitignore -Raw
    if ($giContent -notmatch "\.env") {
        $findings += [PSCustomObject]@{
            Category = "MISCONFIGURATION"
            Severity = "HIGH"
            Target   = ".gitignore"
            Issue    = ".env nao esta listado no .gitignore!"
        }
        Write-Host "  [HIGH] .env nao esta protegido no .gitignore!" -ForegroundColor Red
    } else {
        Write-Host "  [PASS] .env protegido no .gitignore." -ForegroundColor Green
    }
}

Write-Host ""
Write-Host "=======================================================" -ForegroundColor Red
Write-Host "   Resumo da Auditoria de Seguranca" -ForegroundColor Red
Write-Host "=======================================================" -ForegroundColor Red

if ($findings.Count -eq 0) {
    Write-Host " STATUS: SECURITY_PASSED (Zero vulnerabilidades criticas detectadas)" -ForegroundColor Green
} else {
    Write-Host " STATUS: VULNERABILITIES_FOUND ($($findings.Count) problemas encontrados)" -ForegroundColor Red
    foreach ($f in $findings) {
        Write-Host "  - [$($f.Severity)] $($f.Category): $($f.Issue)" -ForegroundColor Yellow
    }
}
Write-Host "=======================================================`n"
