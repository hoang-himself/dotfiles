function Get-Asset {
  $scriptBlockList = @();

  Push-Location -Path 'Assets';

  New-Item -ItemType Directory -Path 'winget-cli' -Force;

  $scriptBlockList += {
    Invoke-WebRequest -Uri 'https://github.com/abbodi1406/vcredist/releases/latest/download/VisualCppRedist_AIO_x86_x64.exe' `
      -OutFile 'VisualCppRedist_AIO_x86_x64.exe';
  }

  $scriptBlockList += {
    [array](Invoke-RestMethod -Method 'GET' -Uri 'https://api.github.com/repos/M2Team/NanaZip/releases') `
    | Where-Object -FilterScript { -not $_.prerelease } `
    | Select-Object -First 1 -ExpandProperty assets `
    | Where-Object -FilterScript { $_.name -like '*.msixbundle' } `
    | Select-Object -ExpandProperty browser_download_url `
    | ForEach-Object { Invoke-WebRequest -Uri "$_" -OutFile '40174MouriNaruto.NanaZip_gnj4mf6z9tkrc.msixbundle'; }
  }

  $scriptBlockList += {
    Invoke-WebRequest -Uri 'https://www.nuget.org/api/v2/package/Microsoft.UI.Xaml' `
      -OutFile 'microsoft.ui.xaml.nupkg';

    Expand-Archive -Path 'microsoft.ui.xaml.nupkg' -DestinationPath 'microsoft.ui.xaml' -Force;
    Remove-Item -Path 'microsoft.ui.xaml.nupkg' -Force;

    Copy-Item -Path 'microsoft.ui.xaml\tools\AppX\x64\Release\*' -Recurse -Destination 'winget-cli\' -Force;
    Remove-Item -Path 'microsoft.ui.xaml' -Recurse -Force;
  }

  $scriptBlockList += {
    Invoke-WebRequest -Uri 'https://github.com/microsoft/winget-cli/releases/latest/download/DesktopAppInstaller_Dependencies.zip' `
      -OutFile 'DesktopAppInstaller_Dependencies.zip';

    Expand-Archive -Path '.\DesktopAppInstaller_Dependencies.zip' -DestinationPath '.\DesktopAppInstaller_Dependencies' -Force;
    Remove-Item -Path 'DesktopAppInstaller_Dependencies.zip' -Force;

    Copy-Item -Path 'DesktopAppInstaller_Dependencies\x64\*' -Recurse -Destination 'winget-cli\' -Force;
    Remove-Item -Path 'DesktopAppInstaller_Dependencies' -Recurse -Force;
  }

  $scriptBlockList += {
    Invoke-WebRequest -Uri 'https://github.com/microsoft/winget-cli/releases/latest/download/Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle' `
      -OutFile 'Microsoft.DesktopAppInstaller_8wekyb3d8bbwe.msixbundle';
  }

  $scriptBlockList += {
    Invoke-WebRequest -Uri 'https://officecdn.microsoft.com/pr/wsus/setup.exe' `
      -OutFile 'Office\setup.exe';
    Start-Process -WorkingDirectory '.\Office' -FilePath 'setup.exe' -ArgumentList @('/download', 'O365ProPlusRetail.xml') -WindowStyle Minimized;
  }

  $scriptBlockList | ForEach-Object { Start-Job -ScriptBlock $_ };

  Get-Job | Wait-Job;

  Pop-Location;
}

function Get-Script {
  $scriptBlockList = @();

  Push-Location -Path 'Scripts';

  $scriptBlockList += {
    Invoke-WebRequest -Uri 'https://raw.githubusercontent.com/massgravel/Microsoft-Activation-Scripts/master/MAS/All-In-One-Version-KL/MAS_AIO.cmd' `
      -OutFile 'MAS_AIO.cmd';
  }

  $scriptBlockList | ForEach-Object { Start-Job -ScriptBlock $_ };

  Get-Job | Wait-Job;

  Pop-Location;
}

Get-Asset;
Get-Script;
