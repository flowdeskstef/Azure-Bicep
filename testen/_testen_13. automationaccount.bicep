param location string = 'westeurope'

@description('URI to the NATrule_RDP PowerShell script (raw .ps1)')
param natRuleScriptUri string = 'avd_nat_rule_rdp.ps1'

@description('URI to the enable_acc_networking PowerShell script (raw .ps1)')
param accNetScriptUri string = 'acc_networking.ps1'

resource automation 'Microsoft.Automation/automationAccounts@2024-10-23' = {
  name: 'AVD-AA'
  location: location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    publicNetworkAccess: false
    sku: {
      name: 'Basic'
    }
  }
}

resource runtime 'Microsoft.Automation/automationAccounts/runtimeEnvironments@2024-10-23' = {
  name: 'PowerShell-72'
  location: location
  parent: automation
  properties: {
    runtime: {
      language: 'PowerShell'
      version: '7.2'
    }
  }
}

resource runbook 'Microsoft.Automation/automationAccounts/runbooks@2024-10-23' = {
  name: 'RDP-NATRULE'
  location: location
  parent: automation
  properties: {
    runbookType: 'PowerShell'
     runtimeEnvironment: runtime.name
      publishContentLink: {
         uri: natRuleScriptUri
      }
  }
}


output rechten string = 'Let op: zorg ervoor dat je rbac rechten in code toekent! Dit kan helaas niet via azure bicep'

// scope: subscription
// identity: Automation account identity
// roles: Contributor
