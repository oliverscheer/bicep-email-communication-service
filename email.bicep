param isProd bool = false
param communicationServiceName string = 'cs-oliverscheer-net'
param emailServiceName string = 'es-oliverscheer-net'

// Email Communication Service
resource emailService 'Microsoft.Communication/emailServices@2023-03-31' = {
  name: emailServiceName
  location: 'global'
  properties: {
    dataLocation: 'Europe'
  }
}

// Email Communication Services Domain (Azure Managed)
resource emailServiceAzureDomain 'Microsoft.Communication/emailServices/domains@2023-03-31' = if (!isProd) {
  parent: emailService
  name: 'AzureManagedDomain'
  location: 'global'
  properties: {
    domainManagement: 'AzureManaged'
    userEngagementTracking: 'Disabled'
  }
}

// SenderUsername (Azure Managed Domain)
resource senderUserNameAzureDomain 'Microsoft.Communication/emailServices/domains/senderUsernames@2023-03-31' = if (!isProd) {
  parent: emailServiceAzureDomain
  name: 'donotreply'
  properties: {
    username: 'DoNotReply'
    displayName: 'DoNotReply'
  }
}

// Email Communication Services Domain (Customer Managed)
resource emailServiceCustomDomain 'Microsoft.Communication/emailServices/domains@2023-03-31' = if (isProd) {
  parent: emailService
  name: 'oliverscheer.net'
  location: 'global'
  properties: {
    domainManagement: 'CustomerManaged '
    userEngagementTracking: 'Disabled'
  }
}

// SenderUsername (Customer Managed Domain)
resource senderUserNameCustomDomain 'Microsoft.Communication/emailServices/domains/senderUsernames@2023-03-31' = if (isProd) {
  parent: emailServiceCustomDomain
  name: 'donotreply'
  properties: {
    username: 'DoNotReply'
    displayName: 'DoNotReply'
  }
}

// Link the correct domain based on the environment
var emailServiceResource = isProd ? emailServiceCustomDomain.id : emailServiceAzureDomain.id

// Communication Service
resource communcationService 'Microsoft.Communication/communicationServices@2023-03-31' = {
  name: communicationServiceName
  location: 'global'
  properties: {
    dataLocation: 'Europe'
    linkedDomains: [
      emailServiceResource
    ]
  }
}

// put this connection string into a key vault or (even better) use a Managed Identity to access Communication Service
var communicationServiceConnectionString = communcationService.listKeys().primaryConnectionString
