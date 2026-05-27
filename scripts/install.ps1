# Nimbus 安装脚本 — 支持自定义安装路径
param(
    [Parameter(Mandatory=$false)]
    [string]$MsiPath,

    [Parameter(Mandatory=$false)]
    [string]$InstallPath
)

$scriptDir = Split-Path -Parent $MyInvocation.MyCommand.Path
$installerDir = Join-Path $scriptDir "Installer"

# Auto-detect version
if (-not $MsiPath) {
    $aiMsi    = Join-Path $installerDir "Nimbus_AI.msi"
    $stdMsi   = Join-Path $installerDir "Nimbus_Standard.msi"
    if (Test-Path $aiMsi) {
        Write-Host "Found AI edition: $aiMsi"
        Write-Host "For Standard edition, use: .\install.ps1 -MsiPath `"$stdMsi`""
        $MsiPath = $aiMsi
    } elseif (Test-Path $stdMsi) {
        Write-Host "Found Standard edition: $stdMsi"
        $MsiPath = $stdMsi
    } else {
        Write-Error "No MSI found in $installerDir"
        exit 1
    }
}

if (-not (Test-Path $MsiPath)) {
    Write-Error "MSI not found: $MsiPath"
    exit 1
}

# Prompt for install path if not provided
if (-not $InstallPath) {
    $defaultPath = Join-Path ${env:ProgramFiles} "Nimbus"
    $InstallPath = Read-Host "Install path (Enter for default: $defaultPath)"
    if ([string]::IsNullOrWhiteSpace($InstallPath)) {
        $InstallPath = $defaultPath
    }
}

Write-Host ""
Write-Host "Installing Nimbus to: $InstallPath"
Write-Host ""

$msiArgs = @(
    "/i", "`"$MsiPath`"",
    "/qn",
    "INSTALLFOLDER=`"$InstallPath`"",
    "/L*V", "`"$env:TEMP\Nimbus_Install.log`""
)

$process = Start-Process msiexec.exe -ArgumentList $msiArgs -Wait -PassThru -NoNewWindow

if ($process.ExitCode -eq 0) {
    Write-Host "Installation complete!" -ForegroundColor Green
    Write-Host "Launch from: $InstallPath\Nimbus.exe"
} else {
    Write-Host "Installation failed (exit code: $($process.ExitCode))" -ForegroundColor Red
    Write-Host "See log: $env:TEMP\Nimbus_Install.log"
    exit $process.ExitCode
}
