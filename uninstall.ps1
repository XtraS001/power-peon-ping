# uninstall.ps1 - Uninstall power-peon-ping OpenCode plugin
# Usage:
#   powershell -ExecutionPolicy Bypass -File uninstall.ps1

Set-StrictMode -Version Latest
$ErrorActionPreference = "Stop"

$PluginName = "power-peon-ping"
$PluginsDir = Join-Path $env:USERPROFILE ".config\opencode\plugins"
$PluginFile = Join-Path $PluginsDir "$PluginName.ts"
$AudioDir = Join-Path $env:LOCALAPPDATA "OpenCode\$PluginName\audio"
$AudioParentDir = Join-Path $env:LOCALAPPDATA "OpenCode\$PluginName"

Write-Host "=== power-peon-ping Uninstaller ===" -ForegroundColor Cyan
Write-Host ""

function Remove-PathSafe {
  param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][string]$Label
  )

  try {
    if (Test-Path $Path) {
      Remove-Item $Path -Recurse -Force
      Write-Host "$Label removed: $Path" -ForegroundColor Green
    } else {
      Write-Host "$Label not found: $Path" -ForegroundColor Yellow
    }
  } catch {
    Write-Host "ERROR removing $Label at ${Path}: $($_.Exception.Message)" -ForegroundColor Red
  }
}

function Remove-DirIfEmpty {
  param(
    [Parameter(Mandatory = $true)][string]$Path,
    [Parameter(Mandatory = $true)][string]$Label
  )

  try {
    if (Test-Path $Path) {
      $items = @(Get-ChildItem -Path $Path -Force -ErrorAction Stop)
      if ($items.Count -eq 0) {
        Remove-Item $Path -Force
        Write-Host "$Label removed (empty): $Path" -ForegroundColor Green
      } else {
        Write-Host "$Label not empty, leaving: $Path" -ForegroundColor Yellow
      }
    } else {
      Write-Host "$Label not found: $Path" -ForegroundColor Yellow
    }
  } catch {
    Write-Host "ERROR checking/removing $Label at ${Path}: $($_.Exception.Message)" -ForegroundColor Red
  }
}

try {
  Remove-PathSafe -Path $PluginFile -Label "Plugin file"
  Remove-PathSafe -Path $AudioDir -Label "Audio directory"
  Remove-DirIfEmpty -Path $AudioParentDir -Label "Audio parent directory"

  Write-Host ""
  Write-Host "=== Uninstall Complete ===" -ForegroundColor Green
} catch {
  Write-Host "ERROR: $($_.Exception.Message)" -ForegroundColor Red
}
