# install.ps1 - Install power-peon-ping OpenCode plugin
# Usage:
#   powershell -ExecutionPolicy Bypass -File install.ps1
#   iwr -useb "https://raw.githubusercontent.com/XtraS001/power-peon-ping/main/install.ps1" | iex
#
# Parameters:
#   -Repo owner/repo    GitHub repository (default: XtraS001/power-peon-ping)
#   -Branch main        Branch name (default: main)
#   -Force              Skip overwrite prompt

param(
  [string]$Repo = "XtraS001/power-peon-ping",
  [string]$Branch = "main",
  [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$ZipUrl = "https://github.com/$Repo/archive/refs/heads/$Branch.zip"

$PluginName = "power-peon-ping"
$PluginDir = Join-Path $env:USERPROFILE ".config\opencode\plugins\$PluginName"
$PluginFile = Join-Path $PluginDir "power-peon-ping.ts"
$AudioDir = Join-Path $env:LOCALAPPDATA "OpenCode\$PluginName\audio"

Write-Host "=== power-peon-ping Installer ===" -ForegroundColor Cyan
Write-Host ""

if (Test-Path $PluginDir) {
  if (-not $Force) {
    $ans = Read-Host "Plugin directory exists at $PluginDir. Overwrite? (y/N)"
    if ($ans -ne "y" -and $ans -ne "Y") {
      Write-Host "Aborted." -ForegroundColor Yellow
      exit 0
    }
  }
  Remove-Item $PluginDir -Recurse -Force
  Write-Host "Removed existing plugin directory." -ForegroundColor Yellow
}

if (Test-Path $AudioDir) {
  if (-not $Force) {
    $ans = Read-Host "Audio directory exists at $AudioDir. Overwrite? (y/N)"
    if ($ans -ne "y" -and $ans -ne "Y") {
      Write-Host "Aborted." -ForegroundColor Yellow
      exit 0
    }
  }
  Remove-Item $AudioDir -Recurse -Force
  Write-Host "Removed existing audio directory." -ForegroundColor Yellow
}

$TempDir = Join-Path $env:TEMP "peon-ping-install-$([guid]::NewGuid().ToString())"
$ZipPath = Join-Path $TempDir "repo.zip"

try {
  New-Item -ItemType Directory -Path $TempDir -Force | Out-Null

  Write-Host "Downloading from $ZipUrl ..." -ForegroundColor Cyan
  Invoke-WebRequest -Uri $ZipUrl -OutFile $ZipPath -UseBasicParsing
  Write-Host "Download complete." -ForegroundColor Green

  Write-Host "Extracting archive..." -ForegroundColor Cyan
  Expand-Archive -Path $ZipPath -DestinationPath $TempDir -Force
  Write-Host "Extraction complete." -ForegroundColor Green

  $ExtractedDir = Get-ChildItem $TempDir -Directory | Where-Object { $_.Name -ne "repo.zip" } | Select-Object -First 1
  if (-not $ExtractedDir) {
    Write-Host "ERROR: Could not find extracted directory." -ForegroundColor Red
    exit 1
  }
  $SourceRoot = $ExtractedDir.FullName

  $PluginSource = Join-Path $SourceRoot "opencode\plugin\$PluginName.ts"
  if (-not (Test-Path $PluginSource)) {
    $PluginSource = Join-Path $SourceRoot "$PluginName.ts"
  }
  if (-not (Test-Path $PluginSource)) {
    $PluginSource = Join-Path $SourceRoot "opencode\plugin\power-peon-ping"
  }
  if (-not (Test-Path $PluginSource)) {
    $PluginSource = Join-Path $SourceRoot "power-peon-ping"
  }

  if (-not (Test-Path $PluginSource)) {
    Write-Host "ERROR: Plugin file not found in archive." -ForegroundColor Red
    Write-Host "Searched for: opencode/plugin/power-peon-ping.ts, power-peon-ping.ts, power-peon-ping" -ForegroundColor Red
    exit 1
  }

  $AudioSource = Join-Path $SourceRoot "audio"
  if (-not (Test-Path $AudioSource)) {
    Write-Host "ERROR: Audio directory not found in archive." -ForegroundColor Red
    exit 1
  }

  Write-Host "Installing plugin to $PluginDir ..." -ForegroundColor Cyan
  New-Item -ItemType Directory -Path $PluginDir -Force | Out-Null
  Copy-Item $PluginSource $PluginFile -Force
  Write-Host "Plugin installed: $PluginFile" -ForegroundColor Green

  Write-Host "Installing audio to $AudioDir ..." -ForegroundColor Cyan
  New-Item -ItemType Directory -Path $AudioDir -Force | Out-Null
  Copy-Item "$AudioSource\*" $AudioDir -Recurse -Force
  Write-Host "Audio installed: $AudioDir" -ForegroundColor Green

  Write-Host ""
  Write-Host "=== Installation Complete ===" -ForegroundColor Green
  Write-Host "Plugin: $PluginFile" -ForegroundColor Green
  Write-Host "Audio:  $AudioDir" -ForegroundColor Green
  Write-Host ""
  Write-Host "Restart OpenCode to load the plugin." -ForegroundColor Cyan

} catch {
  Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
  exit 1
} finally {
  if (Test-Path $TempDir) {
    Remove-Item $TempDir -Recurse -Force
  }
}
