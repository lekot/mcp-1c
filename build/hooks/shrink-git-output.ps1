# Hook: beforeShellExecution. For "git status" / "git diff" run command in cwd,
# return short summary so full output does not fill agent context. Allow git add / git commit.
# Can be called with -InputFile <path> by wrapper (Node) when stdin is not available on Windows.
param([string]$InputFile)
$ErrorActionPreference = 'Stop'
if ($InputFile -and (Test-Path -LiteralPath $InputFile)) {
    $inputJson = Get-Content -LiteralPath $InputFile -Raw -Encoding UTF8
} else {
    try {
        $inputJson = [System.IO.StreamReader]::new([System.Console]::In).ReadToEnd()
    } catch {
        Write-Host '{"permission":"allow"}'
        exit 0
    }
}
if ([string]::IsNullOrWhiteSpace($inputJson)) {
    Write-Host '{"permission":"allow"}'
    exit 0
}
try {
    $data = $inputJson | ConvertFrom-Json
} catch {
    Write-Host '{"permission":"allow"}'
    exit 0
}
$cmd = $data.command
$cwd = $data.cwd
if (-not $cwd) { $cwd = $PWD.Path }

# Only handle git status / git diff (matcher already filters, but double-check)
if ($cmd -notmatch 'git\s+(status|diff)') {
    Write-Host '{"permission":"allow"}'
    exit 0
}

$summary = ''
try {
    Push-Location $cwd
    try {
        $out = Invoke-Expression $cmd 2>&1 | Out-String
        $out = $out.Trim()
        if ($cmd -match 'git\s+diff') {
            $lines = $out -split "`n"
            $last = $lines[-1]
            if ($last -match '(\d+)\s+files?\s+changed') {
                $summary = $last
            } else {
                $summary = $lines.Count + " lines. git add -A && git commit -m `"...`""
            }
        } else {
            $shortOut = git status --short 2>&1 | Out-String
            $lines = ($shortOut -split "`n" | Where-Object { $_.Trim() -ne '' })
            $n = $lines.Count
            $summary = "$n file(s). git add -A && git commit -m `"<msg>`""
        }
    } finally {
        Pop-Location
    }
} catch {
    $summary = "git failed. git add -A && git commit -m `"<msg>`""
}

$agent_message = $summary

[Console]::OutputEncoding = [System.Text.Encoding]::UTF8
$obj = @{ permission = "deny"; agent_message = $agent_message }
Write-Host ($obj | ConvertTo-Json -Compress)
exit 0
