param location string = 'westeurope'

// ---- Host pool you want to attach ----
@description('Subscription ID containing the host pool.')
param hostPoolSubscriptionId string = subscription().subscriptionId

@description('Resource group containing the host pool.')
param hostPoolResourceGroup string = 'RG-AVD'

// Look up the host pool and use its id for hostPoolArmPath
resource hostPool 'Microsoft.DesktopVirtualization/hostPools@2026-01-01-preview' existing = {
  name: 'avd-hostpool'
  scope: resourceGroup(hostPoolSubscriptionId, hostPoolResourceGroup)
}

resource scalingplan 'Microsoft.DesktopVirtualization/scalingPlans@2026-01-01-preview' = {
  name: 'AVD-ScalingPlan'
  location: location
  properties: {
    hostPoolType: 'Pooled'
    timeZone: 'W. Europe Standard Time'
    hostPoolReferences: [
       {
        scalingPlanEnabled: true
        hostPoolArmPath: hostPool.id
       }
    ]
    schedules: [
       {
        name: 'daily_replacement'
        scalingMethod: 'CreateDeletePowerManage'
        daysOfWeek: [
          'Monday'
          'Tuesday'
          'Wednesday'
          'Thursday'
          'Sunday'
        ]
        // Start of the day (spin up capacity)
        rampUpStartTime: { hour: 0, minute: 30 }
        rampUpLoadBalancingAlgorithm: 'BreadthFirst'
        rampUpCapacityThresholdPct: 60       // add hosts when utilization exceeds 75%
        rampUpMinimumHostsPct: 20            // keep at least 20% of hosts running

        // Peak hours
        peakStartTime: { hour: 6, minute: 30 }
        peakLoadBalancingAlgorithm: 'BreadthFirst'

        // Ramp down (shut down excess)
        rampDownStartTime: { hour: 23, minute: 58 }
        rampDownLoadBalancingAlgorithm: 'BreadthFirst'
        rampDownCapacityThresholdPct: 90     // start removing hosts below 30% utilization
        rampDownMinimumHostsPct: 0         // but keep 10% running
        rampDownForceLogoffUsers: false      // true = force logoff after wait below
        rampDownWaitTimeMinutes: 30          // wait before power actions
        rampDownStopHostsWhen: 'ZeroSessions' // only stop when no active sessions

        // Off-peak period
        offPeakStartTime: { hour: 23, minute: 59 }
        offPeakLoadBalancingAlgorithm: 'BreadthFirst'

        // Only used when scalingMethod == 'Dynamic' (preview)
        // Ignored by PowerManagement
        
        createDelete: {
          rampUpMinimumHostPoolSize: 1       // min VM count during ramp-up
          rampUpMaximumHostPoolSize: 1      // max VM count during ramp-up
          rampDownMinimumHostPoolSize: 0     // min VM count during ramp-down/off-peak
          rampDownMaximumHostPoolSize: 0    // cap during ramp-down
        }
       }
       {
        name: 'weekend'
        scalingMethod: 'CreateDeletePowerManage'
        daysOfWeek: [
          'Friday'
          'Saturday'
        ]
        // Start of the day (spin up capacity)
        rampUpStartTime: { hour: 0, minute: 30 }
        rampUpLoadBalancingAlgorithm: 'BreadthFirst'
        rampUpCapacityThresholdPct: 60       // add hosts when utilization exceeds 75%
        rampUpMinimumHostsPct: 100            // keep at least 100% of hosts running

        // Peak hours
        peakStartTime: { hour: 6, minute: 30 }
        peakLoadBalancingAlgorithm: 'BreadthFirst'

        // Ramp down (shut down excess)
        rampDownStartTime: { hour: 23, minute: 58 }
        rampDownLoadBalancingAlgorithm: 'BreadthFirst'
        rampDownCapacityThresholdPct: 90     // start removing hosts below 30% utilization
        rampDownMinimumHostsPct: 100          // but keep 10% running
        rampDownForceLogoffUsers: false      // true = force logoff after wait below
        rampDownWaitTimeMinutes: 30          // wait before power actions
        rampDownStopHostsWhen: 'ZeroSessions' // only stop when no active sessions

        // Off-peak period
        offPeakStartTime: { hour: 23, minute: 59 }
        offPeakLoadBalancingAlgorithm: 'BreadthFirst'

        // Only used when scalingMethod == 'Dynamic' (preview)
        // Ignored by PowerManagement
        
        createDelete: {
          rampUpMinimumHostPoolSize: 1       // min VM count during ramp-up
          rampUpMaximumHostPoolSize: 1      // max VM count during ramp-up
          rampDownMinimumHostPoolSize: 1     // min VM count during ramp-down/off-peak
          rampDownMaximumHostPoolSize: 1    // cap during ramp-down
        }
       }
    ]
  }
}

output dc string = 'Let op: koppel die nieuwe avd machine aan de load balancer, zodat je met rdp erbij kan komen'


// test

