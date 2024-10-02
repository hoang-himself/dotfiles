function Get-Asset {
  $scriptBlockList = @();

  $scriptBlockList += {
    Invoke-WebRequest -Uri 'https://update.code.visualstudio.com/latest/win32-x64-user/stable' `
      -Headers @{ 'User-Agent' = 'Wget x64' } `
      -OutFile 'Assets/vscode.exe';
  }

  $scriptBlockList += {
    Invoke-WebRequest -Uri 'https://sourceforge.net/projects/sevenzip/files/latest/download' `
      -Headers @{ 'User-Agent' = 'Wget x64' } `
      -OutFile 'Assets/7z-x64.exe';
  }

  $scriptBlockList | ForEach-Object { Start-Job -ScriptBlock $_ };

  while (Get-Job -State 'Running') {
    Start-Sleep -Seconds 1;
  }
}

Get-Asset;
