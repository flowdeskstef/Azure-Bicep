var customize = [
  {
    destination: 'C:\\AVDImage\\installLanguagePacks.ps1'
    name: 'avdBuiltInScript_installLanguagePacks'
    sourceUri: 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/CustomImageTemplateScripts/CustomImageTemplateScripts_2024-03-27/InstallLanguagePacks.ps1'
    type: 'File'
  }
  {
    inline: [
      'C:\\AVDImage\\installLanguagePacks.ps1 -LanguageList "Dutch (Netherlands)"'
    ]
    name: 'avdBuiltInScript_installLanguagePacks-parameter'
    runAsSystem: true
    runElevated: true
    type: 'PowerShell'
  }
  {
    name: 'avdBuiltInScript_installLanguagePacks-windowsUpdate'
    type: 'WindowsUpdate'
    updateLimit: 0
  }
  {
    name: 'avdBuiltInScript_installLanguagePacks-windowsRestart'
    restartTimeout: '10m'
    type: 'WindowsRestart'
  }
  {
    destination: 'C:\\AVDImage\\SetDefaultLang.ps1'
    name: 'avdBuiltInScript_SetDefaultLang'
    sourceUri: 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/CustomImageTemplateScripts/CustomImageTemplateScripts_2024-03-27/SetDefaultLang.ps1'
    type: 'File'
  }
  {
    inline: [
      'C:\\AVDImage\\SetDefaultLang.ps1 -Language "Dutch (Netherlands)"'
    ]
    name: 'avdBuiltInScript_SetDefaultLang-parameter'
    runAsSystem: true
    runElevated: true
    type: 'PowerShell'
  }
  {
    name: 'avdBuiltInScript_timeZoneRedirection'
    runAsSystem: true
    runElevated: true
    scriptUri: 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/CustomImageTemplateScripts/CustomImageTemplateScripts_2024-03-27/TimezoneRedirection.ps1'
    type: 'PowerShell'
  }
  {
    name: 'avdBuiltInScript_configureRdpShortpath'
    runAsSystem: true
    runElevated: true
    scriptUri: 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/CustomImageTemplateScripts/CustomImageTemplateScripts_2024-03-27/RDPShortpath.ps1'
    type: 'PowerShell'
  }
  {
    destination: 'C:\\AVDImage\\TeamsOptimization.ps1'
    name: 'avdBuiltInScript_teamsOptimization'
    sourceUri: 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/CustomImageTemplateScripts/CustomImageTemplateScripts_2024-03-27/TeamsOptimization.ps1'
    type: 'File'
  }
  {
    inline: [
      'C:\\AVDImage\\TeamsOptimization.ps1 -WebRTCInstaller "https://aka.ms/msrdcwebrtcsvc/msi" -VCRedistributableLink "https://aka.ms/vs/17/release/vc_redist.x64.exe" -TeamsBootStrapperUrl "https://go.microsoft.com/fwlink/?linkid=2243204&clcid=0x409"'
    ]
    name: 'avdBuiltInScript_teamsOptimization-parameter'
    runAsSystem: true
    runElevated: true
    type: 'PowerShell'
  }
  {
    destination: 'C:\\AVDImage\\multiMediaRedirection.ps1'
    name: 'avdBuiltInScript_multiMediaRedirection'
    sourceUri: 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/CustomImageTemplateScripts/CustomImageTemplateScripts_2024-03-27/MultiMediaRedirection.ps1'
    type: 'File'
  }
  {
    inline: [
      'C:\\AVDImage\\multiMediaRedirection.ps1 -VCRedistributableLink "https://aka.ms/vs/17/release/vc_redist.x64.exe" -EnableEdge "true" -EnableChrome "false"'
    ]
    name: 'avdBuiltInScript_multiMediaRedirection-parameter'
    runAsSystem: true
    runElevated: true
    type: 'PowerShell'
  }
  {
    destination: 'C:\\AVDImage\\windowsOptimization.ps1'
    name: 'avdBuiltInScript_windowsOptimization'
    sourceUri: 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/CustomImageTemplateScripts/CustomImageTemplateScripts_2024-03-27/WindowsOptimization.ps1'
    type: 'File'
  }
  {
    inline: [
      'C:\\AVDImage\\windowsOptimization.ps1 -Optimizations "DefaultUserSettings"'
    ]
    name: 'avdBuiltInScript_windowsOptimization-parameter'
    runAsSystem: true
    runElevated: true
    type: 'PowerShell'
  }
  {
  destination: 'C:\\AVDImage\\RemoveAppxPackages.ps1'
  name: 'avdBuiltInScript_removeAppxPackages'
  sourceUri: 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/CustomImageTemplateScripts/CustomImageTemplateScripts_2024-03-27/RemoveAppxPackages.ps1'
  type: 'File'
 }
 {
  inline: [
    'C:\\AVDImage\\RemoveAppxPackages.ps1 -AppxPackages "Microsoft.BingNews","Microsoft.BingWeather","Microsoft.GamingApp","Microsoft.GetHelp","Microsoft.Getstarted","Microsoft.MicrosoftOfficeHub","Microsoft.MicrosoftSolitaireCollection","Microsoft.SkypeApp","Microsoft.WindowsFeedbackHub","Microsoft.Xbox.TCUI","Microsoft.XboxGameOverlay","Microsoft.XboxGamingOverlay","Microsoft.XboxIdentityProvider","Microsoft.XboxSpeechToTextOverlay","Microsoft.XboxApp"'
  ]
  name: 'avdBuiltInScript_removeAppxPackages-parameter'
  runAsSystem: true
  runElevated: true
  type: 'PowerShell'
 }
  {
    name: 'avdBuiltInScript_windowsOptimization-windowsUpdate'
    type: 'WindowsUpdate'
    updateLimit: 0
  }
  {
    name: 'avdBuiltInScript_windowsOptimization-windowsRestart'
    type: 'WindowsRestart'
  }
  {
    name: 'avdBuiltInScript_windowsUpdate'
    type: 'WindowsUpdate'
    updateLimit: 0
  }
  {
    name: 'avdBuiltInScript_windowsUpdate-windowsRestart'
    type: 'WindowsRestart'
  }
  {
    name: 'avdBuiltInScript_adminSysPrep'
    runAsSystem: true
    runElevated: true
    scriptUri: 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/CustomImageTemplateScripts/CustomImageTemplateScripts_2024-03-27/AdminSysPrep.ps1'
    type: 'PowerShell'
  }
]

// Output the customizations array
output customizationsOutput array = customize
