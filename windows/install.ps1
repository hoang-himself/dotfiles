# Self elevate administrative permissions in this script
if (!([Security.Principal.WindowsPrincipal][Security.Principal.WindowsIdentity]::GetCurrent()).IsInRole([Security.Principal.WindowsBuiltInRole] "Administrator")) {
  Start-Process pwsh "-NoProfile -ExecutionPolicy Bypass -File `"$PSCommandPath`"" -Verb RunAs
  exit
}

Set-ExecutionPolicy -ExecutionPolicy RemoteSigned -Force

Import-Module -Name .\packages\common.psm1

function Set-ComputerName {
  $ComputerName = Read-Host -Prompt Enter New Computer Name
  Rename-Computer -NewName $ComputerName
}

function Uninstall-Bloat {
  # Get-AppxPackage | Format-Table -Property Name,Version,PackageFullName
  @(
    "king.com.CandyCrushFriends",
    "Microsoft.3DBuilder",
    "Microsoft.Print3D",
    "Microsoft.BingNews",
    "Microsoft.OneConnect",
    "Microsoft.Microsoft3DViewer",
    "HolographicFirstRun",
    "Microsoft.MixedReality.Portal"
    "Microsoft.MicrosoftSolitaireCollection",
    "Microsoft.Getstarted",
    "Microsoft.WindowsFeedbackHub",
    "Microsoft.XboxApp",
    "Fitbit.FitbitCoach",
    "4DF9E0F8.Netflix"
  ) | ForEach-Object {
    Get-AppxPackage -Name $_ | Remove-AppxPackage
  }
}

function Install-BasePackages {
  @(
    "PowerShellGet",
    "PSReadLine",
    "posh-git"
  ) | ForEach-Object {
    Install-Module -Name $_ -Force
  }
}

function Install-Configs {
  New-RelativeSymbolicItem -Path ~\.ssh\config -Target .\configs\ssh_config
  New-RelativeSymbolicItem -Path ~\.wslconfig -Target .\configs\wslconfig

  $ProfileDir = Split-Path -Parent $Profile
  New-Item -Path $ProfileDir -ItemType Directory -Force -ErrorAction SilentlyContinue

  # https://docs.microsoft.com/en-us/powershell/module/microsoft.powershell.core/about/about_profiles
  Get-ChildItem -Path .\runcoms |
  ForEach-Object {
    New-Item -ItemType SymbolicLink -Path "${ProfileDir}\$($_.Name)" -Target $_.FullName -Force
  }

  Get-ChildItem -Path .\configs\git\ |
  ForEach-Object {
    New-Item -ItemType SymbolicLink -Path "~\.$($_.Name)" -Target $_.FullName -Force
  }

  Get-ChildItem -Path .\configs\gnupg\ |
  ForEach-Object {
    New-Item -ItemType SymbolicLink -Path "~\.gnupg\$($_.Name)" -Target $_.FullName -Force
  }
}

function main {
  Install-BasePackages
  Install-Configs
}

main
