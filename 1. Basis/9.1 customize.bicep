var customize = [
  {
    destination: 'C:\\AVDImage\\installLanguagePacks.ps1'
    name: 'avdBuiltInScript_installLanguagePacks'
    sha256Checksum: '519f1dcb41c15dc1726f28c51c11fb60876304ab9eb9535e70015cdb704a61b2'
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
    sha256Checksum: 'b8dbc50b02f64cc7a99f6eeb7ada676673c9e431255e69f3e7a97a027becd8d5'
    type: 'PowerShell'
  }
  {
    name: 'avdBuiltInScript_configureRdpShortpath'
    runAsSystem: true
    runElevated: true
    scriptUri: 'https://raw.githubusercontent.com/Azure/RDS-Templates/master/CustomImageTemplateScripts/CustomImageTemplateScripts_2024-03-27/RDPShortpath.ps1'
    sha256Checksum: '24e9821ddcc63aceba2682286d03cd7042bcadcf08a74fb0a30a1a1cd0cbf910'
    type: 'PowerShell'
  }
  {
    destination: 'C:\\AVDImage\\TeamsOptimization.ps1'
    name: 'avdBuiltInScript_teamsOptimization'
    sha256Checksum: 'b6e4b30185cb4eb556846ecf9951bacda29ef657230c6ad0924c7f49ab1f6975'
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
    sha256Checksum: 'f577c9079aaa7da399121879213825a3f263f7b067951a234509e72f8b59a7fd'
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
    sha256Checksum: '3a84266be0a3fcba89f2adf284f3cc6cc2ac41242921010139d6e9514ead126f'
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
    sha256Checksum: '1dcaba4823f9963c9e51c5ce0adce5f546f65ef6034c364ef7325a0451bd9de9'
    type: 'PowerShell'
  }
]

// Output the customizations array
output customizationsOutput array = customize
