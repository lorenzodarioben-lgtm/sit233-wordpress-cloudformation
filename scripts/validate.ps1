[CmdletBinding()]
param()

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ScriptDirectory = Split-Path -Parent $MyInvocation.MyCommand.Path
$RepoRoot = (Resolve-Path -LiteralPath (Join-Path $ScriptDirectory "..")).Path
$Templates = @("networking.yaml", "application.yaml")

Write-Host "Repository root: $RepoRoot"

$CfnLint = Get-Command "cfn-lint" -ErrorAction SilentlyContinue
if (-not $CfnLint) {
    Write-Error "cfn-lint was not found on PATH. Install it with: python -m pip install cfn-lint"
    exit 127
}

Push-Location -LiteralPath $RepoRoot
try {
    foreach ($Template in $Templates) {
        if (-not (Test-Path -LiteralPath $Template -PathType Leaf)) {
            Write-Error "Required template not found: $Template"
            exit 1
        }
    }

    Write-Host "Using cfn-lint: $($CfnLint.Source)"
    & $CfnLint.Source --version

    Write-Host "Linting CloudFormation templates..."
    & $CfnLint.Source --non-zero-exit-code error -t @Templates
    $LintExitCode = $LASTEXITCODE

    if ($LintExitCode -ne 0) {
        Write-Error "CloudFormation validation failed with cfn-lint exit code $LintExitCode."
        exit $LintExitCode
    }

    Write-Host "CloudFormation validation completed without error-level findings."
}
finally {
    Pop-Location
}
