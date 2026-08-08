@description('Azure AD App Registration Name')
param ApplicationName string

@description('Azure AD Application ID')
param ApplicationId string

@description('Azure AD Application Object ID')
param ApplicationObjectId string

@description('Client Secret')
@secure()
param ClientSecret string

@description('Tenant ID')
param TenantId string

@description('Web app name.')
@minLength(2)
param WebAppName string = 'wa-${uniqueString(resourceGroup().id)}'

@description('The name of the function app.')
param FunctionAppName string = 'FuncApp-${uniqueString(resourceGroup().id)}'
param StorageAccountName string = 'store${uniqueString(resourceGroup().id)}'

@description('Location for all resources.')
param Location string = resourceGroup().location

var AppServicePlanName = 'asp-${WebAppName}'

@description('Specifies the name of the key vault.')
param KeyVaultName string

@description('Specifies the name of the Azure SQL Server.')
param SqlServerName string

@description('Specifies the name of the Azure SQL Database.')
param DatabaseName string

@description('Specifies current IP address. Required for SQL Server configuration.')
param CurrentIP string

@description('Specifies name of the language service.')
param LanguageServiceName string

@description('Specifies name of the translator.')
param TranslatorName string

@description('Specifies name of the log analytics resource.')
param LogAnalyticsWorkspaceName string

@description('Specifies name of the application insights resource.')
param ApplicationInsightsName string

resource logAnalyticsWorkspace 'Microsoft.OperationalInsights/workspaces@2021-06-01' = {
  name: LogAnalyticsWorkspaceName
  location: Location
  properties: {
    sku: {
      name: 'PerGB2018'
    }
    retentionInDays: 90
    publicNetworkAccessForIngestion: 'Enabled'
    publicNetworkAccessForQuery: 'Enabled'
  }
}

resource applicationInsights 'Microsoft.Insights/components@2020-02-02' = {
  name: ApplicationInsightsName
  location: Location
  kind: 'web'
  properties: {
    Application_Type: 'web'
    WorkspaceResourceId: logAnalyticsWorkspace.id
    Flow_Type: 'Redfield'
  }
}

resource asp 'Microsoft.Web/serverfarms@2022-03-01' = {
  name: AppServicePlanName
  location: Location
  sku: {
    name: 'S1'
  }
}

resource webApp 'Microsoft.Web/sites@2022-03-01' = {
  name: WebAppName
  location: Location
  identity: {
    type: 'SystemAssigned'
  }
  kind: 'app'
  properties: {
    siteConfig: {
      minTlsVersion: '1.2'
      scmMinTlsVersion: '1.2'
      ftpsState: 'FtpsOnly'
      alwaysOn: true
      windowsFxVersion: '.net'
      netFrameworkVersion: 'v7.0'
      cors: {
        allowedOrigins:[
          'https://portal.azure.com'
        ]
      }
      metadata: [
        {
          name: 'CURRENT_STACK'
          value: 'dotnet'
        }
      ]
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: applicationInsights.properties.ConnectionString
        }
        {
          name: 'AppId'
          value: ApplicationId
        }
        {
          name: 'AppSecret'
          value: '@Microsoft.KeyVault(VaultName=${KeyVaultName};SecretName=ClientSecret)'
        }
        {
          name: 'ClientAppId'
          value: ApplicationId
        }
        {
          name: 'ApplicationInsightsInstrumentationKey'
          value: applicationInsights.properties.InstrumentationKey
        }
        {
          name: 'KeyVaultUri'
          value: 'https://${KeyVaultName}${environment().suffixes.keyvaultDns}/'
        }
        {
          name: 'TenantDomain'
          value: TenantId
        }
      ]
    }
    serverFarmId: asp.id
    httpsOnly: true
  }
}

resource storageAccount 'Microsoft.Storage/storageAccounts@2022-09-01' = {
  name: StorageAccountName
  location: Location
  kind: 'StorageV2'
  sku: {
    name: 'Standard_LRS'
  }
}

resource functionApp 'Microsoft.Web/sites@2022-03-01' = {
  name: FunctionAppName
  kind: 'functionapp'
  location: Location
  identity: {
    type: 'SystemAssigned'
  }
  properties: {
    siteConfig: {
      alwaysOn: true
      netFrameworkVersion: 'v6.0'
      powerShellVersion: '7.2'
      appSettings: [
        {
          name: 'APPINSIGHTS_INSTRUMENTATIONKEY'
          value: applicationInsights.properties.InstrumentationKey
        }
        {
          name: 'APPLICATIONINSIGHTS_CONNECTION_STRING'
          value: applicationInsights.properties.ConnectionString
        }
        {
          name: 'FUNCTIONS_WORKER_RUNTIME'
          value: 'powershell'
        }
        {
          name: 'FUNCTIONS_EXTENSION_VERSION'
          value: '~4'
        }
        {
          name: 'FUNCTIONS_WORKER_PROCESS_COUNT'
          value: '10'
        }
        {
          name: 'AzureWebJobsStorage'
          value: 'DefaultEndpointsProtocol=https;AccountName=${StorageAccountName};AccountKey=${storageAccount.listKeys().keys[0].value}'
        }
        {
          name: 'AzureDevOps.Disabled'
          value: 'false'
        }
        {
          name: 'AzureDevOps.Organization'
          value: 'https://dev.azure.com/{Azure DevOps Organization}'
        }
        {
          name: 'AzureDevOps.Project'
          value: '{Azure DevOps Project Name}'
        }
        {
          name: 'AzureDevOps.WorkItemType.AzureServiceHealthAlert'
          value: 'Azure Service Health Alert'
        }
        {
          name: 'AzureDevOps.WorkItemType.AzureUpdate'
          value: 'Azure Update'
        }
        {
          name: 'AzureDevOps.WorkItemType.Office365EndpointsChange'
          value: 'Office 365 Endpoint change'
        }
        {
          name: 'AzureDevOps.WorkItemType.ReleaseMessage'
          value: 'Microsoft Service Health Hub Release'
        }
        {
          name: 'AzureDevOps.WorkItemType.RoadmapCommunication'
          value: 'Microsoft 365 Roadmap'
        }
        {
          name: 'AzureDevOps.WorkItemType.ServiceHealthIssue'
          value: 'Microsoft 365 Service Health'
        }
        {
          name: 'AzureDevOps.WorkItemType.ServiceUpdateMessage'
          value: 'Microsoft 365 Message Center'
        }
        {
          name: 'AzureDevOps.WorkItemType.D365PowerPlatformRelease'
          value: 'Dynamics 365 and Power Platform Release'
        }
        {
          name: 'AzureWebJobs.AzureUpdatesTimer.Disabled'
          value: '1'
        }
        {
          name: 'AzureWebJobs.AzureServiceHealthAlertWebhook.Disabled'
          value: '1'
        }
        {
          name: 'AzureWebJobs.LicenseStatistics.Disabled'
          value: '1'
        }
        {
          name: 'AzureWebJobs.Office365EndpointsChangeTimer.Disabled'
          value: '1'
        }
        {
          name: 'AzureWebJobs.ReleaseMessageTimer.Disabled'
          value: '1'
        }
        {
          name: 'AzureWebJobs.RoadmapNotificationsTimer.Disabled'
          value: '1'
        }
        {
          name: 'AzureWebJobs.ServiceIssuesTimer.Disabled'
          value: '1'
        }
        {
          name: 'AzureWebJobs.ServiceUpdatesTimer.Disabled'
          value: '1'
        }
        {
          name: 'ClientID'
          value: ApplicationId
        }
        {
          name: 'ClientSecret'
          value: '@Microsoft.KeyVault(VaultName=${KeyVaultName};SecretName=ClientSecret)'
        }
        {
          name: 'KeyVaultUri'
          value: 'https://${KeyVaultName}${environment().suffixes.keyvaultDns}/'
        }
        {
          name: 'TenantDomain'
          value: TenantId
        }
        {
          name: 'RehydrateRoadmapItems'
          value: 'false'
        }
        {
          name: 'TaskManager'
          value: 'AzureDevOps'
        }
      ]
    }
    serverFarmId: asp.id
    clientAffinityEnabled: false
  }
}

resource keyVault 'Microsoft.KeyVault/vaults@2021-11-01-preview' = {
  name: KeyVaultName
  location: Location
  properties: {
    enabledForDeployment: false
    enabledForDiskEncryption: false
    enabledForTemplateDeployment: false
    tenantId: TenantId
    enableSoftDelete: true
    softDeleteRetentionInDays: 90
    accessPolicies: [
      {
        objectId: webApp.identity.principalId
        tenantId: webApp.identity.tenantId
        permissions: {
          secrets: ['get', 'list', 'set', 'delete']
        }
      }
      {
        objectId: functionApp.identity.principalId
        tenantId: functionApp.identity.tenantId
        permissions: {
          secrets: ['get', 'list', 'set', 'delete']
        }
      }
      {
        objectId: ApplicationObjectId
        tenantId: TenantId
        permissions: {
          secrets: ['get', 'list', 'set', 'delete']
        }
      }
    ]
    sku: {
      name: 'standard'
      family: 'A'
    }
    networkAcls: {
      defaultAction: 'Allow'
      bypass: 'AzureServices'
    }
  }
}

resource clientSecretSecret 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: keyVault
  name: 'ClientSecret'
  properties: {
    value: ClientSecret
  }
}

resource connectionString 'Microsoft.KeyVault/vaults/secrets@2021-11-01-preview' = {
  parent: keyVault
  name: 'ConnectionString'
  properties: {
    value: 'Data Source=${SqlServerName}${environment().suffixes.sqlServerHostname};Initial Catalog=${DatabaseName};Encrypt=True;'
  }
}

resource sqlServer 'Microsoft.Sql/servers@2022-05-01-preview' = {
  name: SqlServerName
  location: Location
  identity:{
    type: 'SystemAssigned'
  }
  properties: {
    publicNetworkAccess: 'Enabled'
    administrators: {
      azureADOnlyAuthentication: true
      login: ApplicationName
      principalType: 'Application'
      sid: ApplicationId
      tenantId: TenantId
      administratorType: 'ActiveDirectory'
    }
    version: '12.0'
  }
}

resource sqlAzureIPFirewallRule 'Microsoft.Sql/servers/firewallRules@2022-05-01-preview' = {
  parent: sqlServer
  name: 'AllowAllWindowsAzureIps'
  properties: {
    endIpAddress: '0.0.0.0'
    startIpAddress: '0.0.0.0'
  }
}

resource sqlLocalIPFirewallRule 'Microsoft.Sql/servers/firewallRules@2022-05-01-preview' = {
  parent: sqlServer
  name: 'ClientIP'
  properties: {
    endIpAddress: CurrentIP
    startIpAddress: CurrentIP
  }
}

resource sqlConnectionPolicy 'Microsoft.Sql/servers/connectionPolicies@2022-05-01-preview' = {
  parent: sqlServer
  name: 'Default'
  properties: {
    connectionType: 'Default'
  }
}

resource sqlDB 'Microsoft.Sql/servers/databases@2022-05-01-preview' = {
  parent: sqlServer
  name: DatabaseName
  location: Location
  sku: {
    name: 'S0'
    tier: 'Standard'
    capacity: 10
  }
}

resource translator 'Microsoft.CognitiveServices/accounts@2022-03-01' = {
  name: TranslatorName
  location: Location
  kind: 'TextTranslation'
  sku: {
    name: 'S1'
  }
  properties: {
  }
}

resource languageService 'Microsoft.CognitiveServices/accounts@2022-03-01' = {
  name: LanguageServiceName
  location: Location
  kind: 'TextAnalytics'
  sku: {
    name: 'S'
  }
  properties: {
  }
}
