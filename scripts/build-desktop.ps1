# TuColmadoRD Desktop Build Script

$PSScriptRoot = Split-Path -Parent $MyInvocation.MyCommand.Definition
$Root = Resolve-Path "$PSScriptRoot/../.."

# 1. Read version and handle suffix
$package = Get-Content "$PSScriptRoot/../package.json" | ConvertFrom-Json
$baseVersion = $package.version
$suffix = if ($env:RELEASE_TYPE -eq "test") { "-test" } else { "" }
$appVersion = if ($env:APP_VERSION) { $env:APP_VERSION } else { "$baseVersion$suffix" }
$env:APP_VERSION = $appVersion # For Inno Setup

Write-Host "--- TuColmadoRD Build v$appVersion ---" -ForegroundColor Yellow

# 2. Build Angular with configuration 'local'
Write-Host "--- 1. Building Angular (Local) ---" -ForegroundColor Cyan
Set-Location "$Root/src/TuColmadoRD.Frontend/web-admin"
if (-not (Test-Path "node_modules")) { npm install }
npx ng build --configuration local --output-path ../dist-desktop

# 3. Copy dist to wwwroot of the Desktop project
Write-Host "--- 2. Copying Angular build to Desktop wwwroot ---" -ForegroundColor Cyan
$wwwroot = "$Root/src/Presentations/TuColmadoRD.Desktop/wwwroot"
if (Test-Path $wwwroot) { Remove-Item $wwwroot -Recurse -Force }
New-Item -ItemType Directory -Path $wwwroot | Out-Null
Copy-Item "$Root/src/TuColmadoRD.Frontend/dist-desktop/browser/*" $wwwroot -Recurse

# 4. Publish the .exe self-contained
Write-Host "--- 3. Publishing .NET Desktop App ---" -ForegroundColor Cyan
Set-Location $Root
dotnet publish src/Presentations/TuColmadoRD.Desktop/TuColmadoRD.Desktop.csproj `
  --configuration Release `
  --runtime win-x64 `
  --self-contained true `
  -p:PublishSingleFile=true `
  -p:IncludeNativeLibrariesForSelfExtract=true `
  --output ./publish/desktop

Write-Host "✅ .exe listo en ./publish/desktop/TuColmadoRD.Desktop.exe" -ForegroundColor Green

# 5. Compilar installer con Inno Setup (si está instalado)
$inno = "C:\Program Files (x86)\Inno Setup 6\ISCC.exe"
if (Test-Path $inno) {
    Write-Host "--- 4. Generating Installer v$appVersion ---" -ForegroundColor Cyan
    & $inno /DAppVersion=$appVersion "$Root/installer/setup.iss"
    Write-Host "✅ Installer generado en ./publish/installer/TuColmadoRD-Setup-v$appVersion.exe" -ForegroundColor Green
} else {
    Write-Host "⚠️ Inno Setup no encontrado — saltando generación de installer" -ForegroundColor Yellow
}
