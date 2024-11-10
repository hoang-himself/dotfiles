function Get-Asset {
  $scriptBlockList = @();

  Push-Location -Path 'Assets';

  $scriptBlockList += {
    Invoke-WebRequest -Uri 'https://update.code.visualstudio.com/latest/win32-x64-user/stable' `
      -Headers @{ 'User-Agent' = 'Wget x64' } `
      -OutFile 'vscode.exe';
  }

  $scriptBlockList += {
    Invoke-WebRequest -Uri 'https://sourceforge.net/projects/sevenzip/files/latest/download' `
      -Headers @{ 'User-Agent' = 'Wget x64' } `
      -OutFile '7z-x64.exe';
  }

  $scriptBlockList | ForEach-Object { Start-Job -ScriptBlock $_ };

  Get-Job | Wait-Job;

  Pop-Location;
}

Get-Asset;
