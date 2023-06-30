param email string

// https://github.com/Azure/bicep-registry-modules/blob/main/modules/cost/resourcegroup-scheduled-action/README.md
module dailyCostsAlert 'br/public:cost/resourcegroup-scheduled-action:1.0.1' = {
  name: 'AzKoans'
  params: {
    name: 'AzKoans'
    displayName: 'AzKoans'
    builtInView: 'DailyCosts'
    emailRecipients: [ email ]
    notificationEmail: email
    scheduleFrequency: 'Weekly'
    scheduleDaysOfWeek: [ 'Monday' ]
  }
}
