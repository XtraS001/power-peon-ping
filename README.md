# power-peon-ping

An OpenCode plugin that plays peon voice lines on events like user prompts, errors, and idle sessions.

## Requirements

- Windows
- [OpenCode](https://github.com/opencode/opencode) installed
- PowerShell (comes with Windows by default)

## Install

### One-line (PowerShell)

Open **PowerShell** and run:

```powershell
iwr -useb "https://raw.githubusercontent.com/XtraS001/power-peon-ping/main/install.ps1" | iex
```

> `iwr` is a PowerShell alias for `Invoke-WebRequest`. It does **not** work in `cmd`.

### Local file

1. Download `install.ps1` from this repo.
2. Right-click on it and select **Run with PowerShell**, or open PowerShell and run:

```powershell
.\install.ps1
```

### Options

| Option   | Description                          |
| -------- | ------------------------------------ |
| `-Force` | Skip overwrite confirmation prompts  |

Example:

```powershell
.\install.ps1 -Force
```

## What gets installed

| File/Folder   | Destination                                                                 |
| ------------- | --------------------------------------------------------------------------- |
| Plugin file   | `C:\Users\<you>\.config\opencode\plugins\power-peon-ping\power-peon-ping.ts` |
| Audio folder  | `C:\Users\<you>\AppData\Local\OpenCode\power-peon-ping\audio\`               |

The installer creates these directories automatically.

## Uninstall

Delete the plugin folder and audio folder:

```powershell
Remove-Item -Recurse -Force "$env:USERPROFILE\.config\opencode\plugins\power-peon-ping"
Remove-Item -Recurse -Force "$env:LOCALAPPDATA\OpenCode\power-peon-ping\audio"
```

Then restart OpenCode.

## Troubleshooting

- **"iwr is not recognized"**: You are in `cmd`, not PowerShell. Open PowerShell instead.
- **Execution policy error**: Run `Set-ExecutionPolicy -Scope CurrentUser -ExecutionPolicy Bypass` in PowerShell first, then retry the install command.
- **Sounds not playing**: Restart OpenCode after installing.
