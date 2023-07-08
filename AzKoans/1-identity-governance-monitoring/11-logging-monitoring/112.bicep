param budgetName string
param startDt string

// https://learn.microsoft.com/en-us/azure/cost-management-billing/costs/quick-create-budget-bicep?tabs=CLI
resource consumptionBudget 'Microsoft.Consumption/budgets@2021-10-01' = {
  name: budgetName
  properties: {
    amount: 100
    category: 'Cost'
    notifications: {}
    timeGrain: 'Monthly'
    timePeriod: {
      endDate: '2034-12-31'
      startDate: startDt
    }
  }
}
