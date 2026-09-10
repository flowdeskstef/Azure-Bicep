var customize = [
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
