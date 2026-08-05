param location string = 'westeurope'

@description('Name of the Recovery Services Vault')
param vaultName string = 'AVD-Vault'

@description('Name for the backup policy.')
param vmpolicyName string = 'backup-servers'

@description('Name for the backup policy.')
param filespolicyName string = 'backup-files'

@description('Windows time zone ID. Example: W. Europe Standard Time')
param timeZone string = 'W. Europe Standard Time'

@description('ISO 8601 time used for schedule and retention timestamps; date part ignored.')
param backupRunTime string = '2025-12-12T01:00:00Z'

resource recoveryVault 'Microsoft.RecoveryServices/vaults@2025-08-01' = {
  name: vaultName
  location: location
  properties: {
    publicNetworkAccess: 'Disabled'
  }
  sku: {
    name: 'RS0'
    tier: 'Standard'
  }
}

resource filespolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2025-08-01' = {
  name: filespolicyName
  parent: recoveryVault
  properties: {
    // files backup policy
    backupManagementType: 'AzureStorage'
    workLoadType: 'AzureFileShare'
    timeZone: timeZone

    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicy'
      scheduleRunFrequency: 'Daily'
      scheduleRunTimes: [
        backupRunTime
      ]
    }

    // Retention: daily + weekly + monthly + yearly
    vaultRetentionPolicy: {
      snapshotRetentionInDays: 14
      vaultRetention: {
        retentionPolicyType: 'LongTermRetentionPolicy'

      // Daily: 14 days
      dailySchedule: {
        retentionDuration: {
          count: 14
          durationType: 'Days'
        }
        retentionTimes: [
          backupRunTime
        ]
      }

      // Weekly: 6 weeks (Sunday)
      weeklySchedule: {
        daysOfTheWeek: [
          'Sunday'
        ]
        retentionDuration: {
          count: 6
          durationType: 'Weeks'
        }
        retentionTimes: [
          backupRunTime
        ]
      }

      // Monthly: 12 months (First Sunday)
      monthlySchedule: {
        retentionDuration: {
          count: 12
          durationType: 'Months'
        }
        retentionScheduleFormatType: 'Weekly'
        retentionScheduleWeekly: {
          daysOfTheWeek: [
            'Sunday'
          ]
          weeksOfTheMonth: [
            'First'
          ]
        }
        retentionTimes: [
          backupRunTime
        ]
      }

      // Yearly: 2 years (January, First Sunday)
      yearlySchedule: {
        monthsOfYear: [
          'January'
        ]
        retentionDuration: {
          count: 2
          durationType: 'Years'
        }
        retentionScheduleFormatType: 'Weekly'
        retentionScheduleWeekly: {
          daysOfTheWeek: [
            'Sunday'
          ]
          weeksOfTheMonth: [
            'First'
          ]
        }
        retentionTimes: [
          backupRunTime
        ]
      }
    }
  }
  }
}

resource vmpolicy 'Microsoft.RecoveryServices/vaults/backupPolicies@2025-08-01' = {
  name: vmpolicyName
  parent: recoveryVault
  properties: {
    // VM backup policy
    backupManagementType: 'AzureIaasVM'
    policyType: 'V2'                       // Standard VM policy type
    timeZone: timeZone

    // Instant Restore (snapshot) settings
    instantRpRetentionRangeInDays: 2         // keep snapshots for 2 days

    // Daily schedule at 01:00 (local to timeZone)
    schedulePolicy: {
      schedulePolicyType: 'SimpleSchedulePolicyV2'
      scheduleRunFrequency: 'Daily'
      dailySchedule: {
        scheduleRunTimes: [
          backupRunTime                        // only time-of-day is used
        ]
      }
    }

    // Retention: daily + weekly + monthly + yearly
    retentionPolicy: {
      retentionPolicyType: 'LongTermRetentionPolicy'

      // Daily: 14 days
      dailySchedule: {
        retentionDuration: {
          count: 14
          durationType: 'Days'
        }
        retentionTimes: [
          backupRunTime
        ]
      }

      // Weekly: 6 weeks (Sunday)
      weeklySchedule: {
        daysOfTheWeek: [
          'Sunday'
        ]
        retentionDuration: {
          count: 6
          durationType: 'Weeks'
        }
        retentionTimes: [
          backupRunTime
        ]
      }

      // Monthly: 12 months (First Sunday)
      monthlySchedule: {
        retentionDuration: {
          count: 12
          durationType: 'Months'
        }
        retentionScheduleFormatType: 'Weekly'
        retentionScheduleWeekly: {
          daysOfTheWeek: [
            'Sunday'
          ]
          weeksOfTheMonth: [
            'First'
          ]
        }
        retentionTimes: [
          backupRunTime
        ]
      }

      // Yearly: 2 years (January, First Sunday)
      yearlySchedule: {
        monthsOfYear: [
          'January'
        ]
        retentionDuration: {
          count: 2
          durationType: 'Years'
        }
        retentionScheduleFormatType: 'Weekly'
        retentionScheduleWeekly: {
          daysOfTheWeek: [
            'Sunday'
          ]
          weeksOfTheMonth: [
            'First'
          ]
        }
        retentionTimes: [
          backupRunTime
        ]
      }
    }
  }
}
