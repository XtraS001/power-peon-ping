# uninstall.ps1 - Uninstall power-peon-ping OpenCode plugin
# Usage:
#   powershell -ExecutionPolicy Bypass -File uninstall.ps1
#   iwr -useb "https://raw.githubusercontent.com/XtraS001/power-peon-ping/main/uninstall.ps1" | iex
#
# Parameters:
#   -Force              Skip confirmation prompts

param(
  [switch]$Force
)

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$PluginName = "power-peon-ping"
$PluginDir = Join-Path $env:USERPROFILE ".config\opencode\plugins\$PluginName"
$PluginFile = Join-Path $PluginDir "power-peon-ping.ts"
$AudioDir = Join-Path $env:LOCALAPPDATA "OpenCode\$PluginName\audio"

Write-Host "=== power-peon-ping Uninstaller ===" -ForegroundColor Cyan
Write-Host ""

try {
  if (Test-Path $PluginDir) {
    if (-not $Force) {
      $ans = Read-Host "Remove plugin directory at $PluginDir? (y/N)"
      if ($ans -ne "y" -and $ans -ne "Y") {
        Write-Host "Aborted." -ForegroundColor Yellow
        exit 0
      }
    }
    Remove-Item $PluginDir -Recurse -Force
    Write-Host "Removed plugin directory: $PluginDir" -ForegroundColor Green
  } else {
    Write-Host "Plugin directory not found: $PluginDir" -ForegroundColor Yellow
  }

  if (Test-Path $AudioDir) {
    if (-not $Force) {
      $ans = Read-Host "Remove audio directory at $AudioDir? (y/N)"
      if ($ans -ne "y" -and $ans -ne "Y") {
        Write-Host "Aborted." -ForegroundColor Yellow
        exit 0
      }
    }
    Remove-Item $AudioDir -Recurse -Force
    Write-Host "Removed audio directory: $AudioDir" -ForegroundColor Green
  } else {
    Write-Host "Audio directory not found: $AudioDir" -ForegroundColor Yellow
  }

  if (-not (Test-Path $PluginDir) -and -not (Test-Path $AudioDir)) {
    Write-Host "" 
    Write-Host "=== Uninstall Complete ===" -ForegroundColor Green
    Write-Host "Plugin file was: $PluginFile" -ForegroundColor Green
    Write-Host "Audio dir was:   $AudioDir" -ForegroundColor Green
    Write-Host "" 
    Write-Host "Restart OpenCode if it is running." -ForegroundColor Cyan
  }
} catch {
  Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
  exit 1
}
