function Update-WoTAslain {
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
  [CmdletBinding(SupportsShouldProcess)]
  param(
    [string]$Path = 'D:\SteamLibrary\steamapps\common\World of Tanks\asia'
  )

  $ErrorActionPreference = 'Stop';
  $scriptBlockList = @();

  if ($PSCmdlet.ShouldProcess('Generate jobs to install mods')) {
    $scriptBlockList += {
      @"
[Setup]
Lang=en
Dir=$using:Path
Group=(Default)
NoIcons=0
SetupType=custom
Components=modpack,modpack\camera,modpack\camera\zoomin,modpack\camera\zoomin\2_4_6_8_10_12_20_28_34_40_50_60,modpack\camera\horizontalstabilization,modpack\camera\penetrationindicator,modpack\camera\penetrationindicator\reducedarmor,modpack\camera\penetrationindicator\reducedarmor\default,modpack\crosshairs,modpack\crosshairs\battleassistant,modpack\dmgindicator,modpack\dmgindicator\meltys,modpack\aimhelpingmods,modpack\aimhelpingmods\autoaim_indicator,modpack\aimhelpingmods\autoaim_indicator\timesnapping,modpack\aimhelpingmods\autoaim_indicator\timesnapping\1,modpack\aimhelpingmods\balcalcmod,modpack\aimhelpingmods\balcalcmod\q,modpack\gfxenhancers,modpack\gfxenhancers\afr,modpack\gfxenhancers\afr\battle,modpack\gfxenhancers\afr\battle\dogtags,modpack\gfxenhancers\afr\battle\dogtags\removekillerdogtag,modpack\gfxenhancers\afr\battle\dogtags\removevictimdogtag,modpack\various,modpack\various\discord_rich_presence,modpack\various\fast_reconnect
Tasks=install_clean,deletepython
"@ `
      | Out-File -FilePath "$using:Path\aslain.inf" -Encoding ASCII -Force;

      [object](Invoke-RestMethod -Uri 'https://wgmods.net/api/mods/46/' -Method 'GET' -Headers @{ 'X-Requested-With' = 'XMLHttpRequest' }) `
      | Select-Object -ExpandProperty versions `
      | Select-Object -First 1 `
      | ForEach-Object {
        $download_path = "$env:USERPROFILE\Downloads\Programs\$($_.version_file_original_name)";
        if (-not (Test-Path -Path "$download_path")) {
          Invoke-WebRequest -Uri "$($_.download_url)" -OutFile "$download_path";
        }
        & "$download_path" /SILENT /LOADINF="$using:Path\aslain.inf"
      }
    }

    $scriptBlockList += {
      Start-Process -FilePath 'https://wotinspector.com/baactivate';
    }
  }

  if ($PSCmdlet.ShouldProcess('Execute jobs to install mods')) {
    $scriptBlockList | ForEach-Object { Start-Job -ScriptBlock $_ }
    Get-Job | Wait-Job;
  }
}

function Update-WoTSpeak {
  [Diagnostics.CodeAnalysis.SuppressMessageAttribute('PSReviewUnusedParameter', '')]
  [CmdletBinding(SupportsShouldProcess)]
  param(
    [string]$Path = 'D:\SteamLibrary\steamapps\common\World of Tanks\asia',
    [string]$Version = (Select-Xml -Path "$Path\version.xml" -XPath '/version.xml/version' `
    | ForEach-Object { $_.Node }).InnerXml.Split(' ')[1].Substring(2)
  )

  $ErrorActionPreference = 'Stop';
  $scriptBlockList = @();

  if ($PSCmdlet.ShouldProcess('Create temporary directory')) {
    mktmp
  }

  if ($PSCmdlet.ShouldProcess('Generate jobs to install mods')) {
    $scriptBlockList += {
      Invoke-WebRequest -Uri 'https://down.wotspeak.org/zj_mod/TargetDirection.rar' `
        -OutFile 'TargetDirection.rar';

      7z.exe x '-oTargetDirection' 'TargetDirection.rar'

      Copy-Item -Path 'TargetDirection\*' -Exclude @('*.url', '*.txt') `
        -Destination "$using:Path\res_mods\$using:Version\" -Recurse -Force;
    }

    $scriptBlockList += {
      Invoke-WebRequest -Uri 'https://down.wotspeak.org/mods_no_work/525-mod_atac.zip' `
        -OutFile 'ATAC.zip';

      Expand-Archive -Path 'ATAC.zip';

      $variant = Get-ChildItem -Path 'ATAC' | Select-String -Pattern '150';
      Copy-Item -Path "$variant\*" -Exclude @('*.url', '*.txt') `
        -Destination "$using:Path\res_mods\$using:Version\" -Recurse -Force;
    }

    $scriptBlockList += {
      Invoke-WebRequest -Uri 'https://down.wotspeak.org/armor/wg/mod_MGM.zip' `
        -OutFile 'MinimapGunMarkers.zip';

      Expand-Archive -Path 'MinimapGunMarkers.zip';

      Copy-Item -Path 'MinimapGunMarkers\mods' -Exclude @('*.url', '*.txt') `
        -Destination "$using:Path\" -Recurse -Force;
    }

    @(
      'WotspeakDestructionsBeholder',
      'WotspeakRedBall'
    ) | ForEach-Object {
      $scriptBlockList += [scriptblock]::Create(@"
      Invoke-WebRequest -Uri "https://down.wotspeak.org/wotspeakmods/wg/$_.zip" ``
        -OutFile "$_.zip";

      Expand-Archive -Path "$_.zip";

      Copy-Item -Path "$_\mods" -Exclude @('*.url', '*.txt') ``
        -Destination "$Path\" -Recurse -Force;
"@)
    }
  }

  if ($PSCmdlet.ShouldProcess('Execute jobs to install mods')) {
    $scriptBlockList | ForEach-Object { Start-Job -ScriptBlock $_ }
    Get-Job | Wait-Job;
  }

  if ($PSCmdlet.ShouldProcess('Remove temporary directory')) {
    rmtmp
  }
}
