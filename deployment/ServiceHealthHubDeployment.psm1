Import-Module Microsoft.Graph.Authentication
Import-Module Microsoft.Graph.Applications
Import-Module Microsoft.Graph.Users
Import-Module Microsoft.Graph.Identity.DirectoryManagement
Import-Module Az.Accounts -RequiredVersion 2.12.1
Import-Module Az.Resources -RequiredVersion 4.4.0
Import-Module Az.Websites -RequiredVersion 2.8.0

class ServiceHealthHubDeployment {

    [string]$WebAppName = ''
    [string]$FunctionAppName = ''
    [string]$DBServerName = ''
    [string]$DatabaseName = ''
    [string]$AppName = ''
    [string]$AppId = ''
    [string]$AppObjectId = ''
    [string]$ClientSecret = ''
    [string]$TenantId = ''
    [string]$StorageAccountName = ''
    [string]$KeyVaultName = ''
    [string]$LanguageServiceName = ''
    [string]$TranslatorName = ''
    [string]$LogAnalyticsWorkspaceName = ''
    [string]$AppInsightsName = ''
    [string]$ResourceGroup = ''

    ServiceHealthHubDeployment(
        [string]$TenantId,
        [string]$SubscriptionId,
        [string]$ResourceGroup,
        [string]$AADApplicationName,
        [string]$InstanceName
    ) {
        # init
        $this.Connect($TenantId, $SubscriptionId);
        $this.WebAppName = "app-$InstanceName"
        $this.FunctionAppName = "func-$InstanceName"
        $this.DBServerName = "sql-$InstanceName"
        $this.DatabaseName = "sqldb-$InstanceName"
        $this.StorageAccountName = "st" + $($InstanceName -replace '[^a-zA-Z0-9]', '')
        $this.KeyVaultName = "kv-$InstanceName"
        $this.LanguageServiceName = "cog-ls-$InstanceName"
        $this.TranslatorName = "cog-tr-$InstanceName"
        $this.LogAnalyticsWorkspaceName = "log-$InstanceName"
        $this.AppInsightsName = "appi-$InstanceName"
        $this.AppName = $AADApplicationName
        $this.ResourceGroup = $ResourceGroup
    }

    ServiceHealthHubDeployment(
        [string]$TenantId,
        [string]$SubscriptionId,
        [string]$ResourceGroup,
        [string]$AADApplicationName,
        [string]$WebAppName,
        [string]$FunctionAppName,
        [string]$DBServerName,
        [string]$DatabaseName,
        [string]$StorageAccountName,
        [string]$KeyVaultName,
        [string]$LanguageServiceName,
        [string]$TranslatorName,
        [string]$LogAnalyticsWorkspaceName,
        [string]$AppInsightsName
    ) {
        # init
        $this.Connect($TenantId, $SubscriptionId);
        $this.WebAppName = $WebAppName
        $this.FunctionAppName = $FunctionAppName
        $this.DBServerName = $DBServerName
        $this.DatabaseName = $DatabaseName
        $this.StorageAccountName = $($StorageAccountName -replace '[^a-zA-Z0-9]', '')
        $this.KeyVaultName = $KeyVaultName
        $this.LanguageServiceName = $LanguageServiceName
        $this.TranslatorName = $TranslatorName
        $this.LogAnalyticsWorkspaceName = $LogAnalyticsWorkspaceName
        $this.AppInsightsName = $AppInsightsName
        $this.AppName = $AADApplicationName
        $this.ResourceGroup = $ResourceGroup
    }

    [void]Connect(
        [string]$TenantId,
        [string]$SubscriptionId
        ) {
        Connect-AzAccount -TenantId $TenantId -Subscription $SubscriptionId
        $azCtx = Get-AzContext
        Connect-MgGraph -Scopes "Application.Read.All", "Application.ReadWrite.All", "User.Read.All", "RoleManagement.ReadWrite.Directory" -TenantId $azCtx.Tenant.Id
        $this.TenantId = $(Get-MgContext).TenantId
    }

    [void]DeployAzureADAppRegistration() {
        $webAppDefaultDomain = "$($this.WebAppName).azurewebsites.net"
        $passwordCred = @{
            "displayName" = "CommHubClientSecret"
            "endDateTime" = (Get-Date).AddMonths(+24)
        }
        $appPermissions = @(
            @{
                ResourceAppId  = "00000003-0000-0000-c000-000000000000"
                ResourceAccess = @(
                    @{
                        Id   = "14dad69e-099b-42c9-810b-d002981feec1"
                        Type = "Scope"
                    },
                    @{
                        Id   = "7427e0e9-2fba-42fe-b0c0-848c9e6a8182"
                        Type = "Scope"
                    },
                    @{
                        Id   = "e1fe6dd8-ba31-4d61-89e7-88639da4683d"
                        Type = "Scope"
                    },
                    @{
                        Id   = "37f7f235-527c-4136-accd-4a02d197296e"
                        Type = "Scope"
                    },
                    @{
                        Id   = "64a6cdd6-aab1-4aaf-94b8-3cc8405e90d0"
                        Type = "Scope"
                    },
                    @{
                        Id   = "498476ce-e0fe-48b0-b801-37ba7e2685c6"
                        Type = "Role"
                    },
                    @{
                        Id   = "230c1aed-a721-4c5d-9cb4-a90514e508ef"
                        Type = "Role"
                    },
                    @{
                        Id   = "79c261e0-fe76-4144-aad5-bdc68fbe4037"
                        Type = "Role"
                    },
                    @{
                        Id   = "1b620472-6534-4fe6-9df2-4680e8aa28ec"
                        Type = "Role"
                    },
                    @{
                        Id   = "f431331c-49a6-499f-be1c-62af19c34a9d"
                        Type = "Role"
                    },
                    @{
                        Id   = "8116ae0f-55c2-452d-9944-d18420f5b2c8"
                        Type = "Role"
                    }
                )
            }
        )

        $spaSettings = @{
            RedirectUris = @(
                "https://$webAppDefaultDomain",
                "https://$webAppDefaultDomain/auth-end",
                "https://$webAppDefaultDomain/.auth/login/aad/callback"
            )
        }

        $webSettings = @{
            HomePageUrl           = "https://$webAppDefaultDomain"
            RedirectUris          = @(
                "https://$webAppDefaultDomain/signin-oidc"
            )
            ImplicitGrantSettings = @{
                EnableAccessTokenIssuance = $true
                EnableIdTokenIssuance     = $true
            }
        }

        $appRoles = @(
            @{
                AllowedMemberTypes = @(
                    "User"
                )
                Description        = "License reader have access to the license usage, history and forecast reports."
                DisplayName        = "License Reader"
                Id                 = [Guid]::NewGuid().ToString()
                IsEnabled          = $true
                Value              = "LicenseReader"
            },
            @{
                AllowedMemberTypes = @(
                    "User"
                )
                Description        = "Members of this role have access to Microsoft Service Health Hub Admin Center."
                DisplayName        = "Admin"
                Id                 = [Guid]::NewGuid().ToString()
                IsEnabled          = $true
                Value              = "Admin"
            },
            @{
                AllowedMemberTypes = @(
                    "User"
                )
                Description        = "Public role members have access to the public dashboard, published by the IT department."
                DisplayName        = "Public"
                Id                 = [Guid]::NewGuid().ToString()
                IsEnabled          = $true
                Value              = "Public"
            },
            @{
                AllowedMemberTypes = @(
                    "User"
                )
                Description        = "Service Health Readers have the ability to read service health information."
                DisplayName        = "Service Health Reader"
                Id                 = [Guid]::NewGuid().ToString()
                IsEnabled          = $true
                Value              = "ServiceHealthReader"
            },
            @{
                AllowedMemberTypes = @(
                    "User"
                )
                Description        = "This role allows users to read all service communications and edit organisational metadata."
                DisplayName        = "Communication.Write.All"
                Id                 = [Guid]::NewGuid().ToString()
                IsEnabled          = $true
                Value              = "Communication.Write.All"
            }
        )

        $apiConfig = @{
            AcceptMappedClaims          = $null
            KnownClientApplications     = @()
            Oauth2PermissionScopes      = @(
                @{
                    AdminConsentDescription = "Allows an app to access resources in a user context"
                    AdminConsentDisplayName = "Access as User"
                    Id                      = "9fc6f18f-81a8-424e-b090-2fda8781d51c"
                    IsEnabled               = $true
                    Type                    = "User"
                    UserConsentDescription  = "Allows an app to access resources in your context"
                    UserConsentDisplayName  = "Access as User"
                    Value                   = "access_as_user"
                }
            )
            PreAuthorizedApplications   = @(
                @{
                    AppId                  = "5e3ce6c0-2b1f-4285-8d4b-75ee78787346"
                    DelegatedPermissionIds = @(
                        "9fc6f18f-81a8-424e-b090-2fda8781d51c"
                    )
                },
                @{
                    AppId                  = "1fec8e78-bce4-4aaf-ab1b-5451cc387264"
                    DelegatedPermissionIds = @(
                        "9fc6f18f-81a8-424e-b090-2fda8781d51c"
                    )
                }
            )
            RequestedAccessTokenVersion = 2
        }

        # create an app registration
        $app = New-MgApplication -DisplayName $this.AppName -SignInAudience AzureAdMyOrg -Spa $spaSettings -Web $webSettings -RequiredResourceAccess $appPermissions -AppRoles $appRoles -Api $apiConfig
        
        # add client secret
        $cs = Add-MgApplicationPassword -ApplicationId $app.Id -PasswordCredential $passwordCred
        
        # add API endpoint reference
        Update-MgApplication -ApplicationId $app.Id -IdentifierUris @("api://$webAppDefaultDomain/$($app.AppId)")

        # create service principal (enterprise app)
        $servicePrincipal = New-MgServicePrincipal -AppId $app.AppId

        # set current user as Service Health Hub Admin. Required for the portal access and further configuration
        $ctx = Get-MgContext
        $user = Get-MgUser -UserId $ctx.Account
        $adminRole = $app.AppRoles | Where-Object DisplayName -eq "Admin"

        New-MgServicePrincipalAppRoleAssignment `
            -ServicePrincipalId $servicePrincipal.Id `
            -PrincipalId $user.Id `
            -ResourceId $servicePrincipal.Id `
            -AppRoleId $adminRole.Id

        # update internal Application references for further steps
        $this.AppObjectId = $app.Id
        $this.AppId = $app.AppId
        $this.ClientSecret = $cs.SecretText
    }

    [void]DeployAzureResources() {
        $currentIP = $(Invoke-WebRequest -uri "http://ifconfig.me/ip").Content
        if ([string]::IsNullOrWhiteSpace($currentIP)) {
            $currentIP = Read-Host -Prompt "Enter your current public IP address."
            if ([string]::IsNullOrWhiteSpace($currentIP)) {
                throw "Public IP Address is required for completing SQL Database configuration."
            }
        }

        New-AzResourceGroupDeployment -Name "shhDeployment-$([Guid]::NewGuid().ToString())" -ResourceGroupName $this.ResourceGroup -TemplateFile ./ServiceHealthHub.bicep -ApplicationName $this.AppName -ApplicationId $this.AppId -ApplicationObjectId $this.AppObjectId -ClientSecret $(ConvertTo-SecureString $this.ClientSecret -AsPlainText -Force) -TenantId $this.TenantId -WebAppName $this.WebAppName -FunctionAppName $this.FunctionAppName -StorageAccountName $this.StorageAccountName -KeyVaultName $this.KeyVaultName -SqlServerName $this.DBServerName -DatabaseName $this.DatabaseName -CurrentIP $currentIP -LanguageServiceName $this.LanguageServiceName -TranslatorName $this.TranslatorName -LogAnalyticsWorkspaceName $this.LogAnalyticsWorkspaceName -ApplicationInsightsName $this.AppInsightsName
        Restart-AzWebApp -ResourceGroupName $this.ResourceGroup -Name $this.WebAppName
        Restart-AzWebApp -ResourceGroupName $this.ResourceGroup -Name $this.FunctionAppName
    }

    [void]ConfigureSqlDatabasePermissions() {
        $serverServicePrincipalObjectId = (Get-MgServicePrincipal -Filter "DisplayName eq '$($this.DBServerName)'").Id
        $roleId = $(Get-MgDirectoryRole | Where-Object DisplayName -eq "Directory Readers").Id
        New-MgDirectoryRoleMemberByRef -DirectoryRoleId $roleId -OdataId "https://graph.microsoft.com/v1.0/directoryObjects/$serverServicePrincipalObjectId"
        
        Sleep 15

        $body = @{
            grant_type    = "client_credentials";
            scope         = "https://database.windows.net/.default";
            client_id     = $this.AppId;
            client_secret = $this.ClientSecret;
        }

        $t = Invoke-RestMethod -Method Post -Uri "https://login.microsoftonline.com/$($this.TenantId)/oauth2/v2.0/token" -Body $body

        $conn = New-Object System.Data.SqlClient.SqlConnection
        $conn.ConnectionString = "Data Source=$($this.DBServerName).database.windows.net;Initial Catalog=$($this.DatabaseName);Encrypt=True;"
        $conn.AccessToken = $t.access_token

        $conn.Open()

        $sqlStatements = @(
            "CREATE USER [$($this.WebAppName)] FROM EXTERNAL PROVIDER;",
            "EXEC sp_addrolemember N'db_owner', N'$($this.WebAppName)'",
            "CREATE USER [$($this.FunctionAppName)] FROM EXTERNAL PROVIDER;",
            "EXEC sp_addrolemember N'db_owner', N'$($this.FunctionAppName)'"
        )

        foreach ($sqlStatement in $sqlStatements) {
            if ($sqlStatement.Trim().ToUpper -ne "GO") {
                $SqlCmd = New-Object System.Data.SqlClient.SqlCommand
                $SqlCmd.CommandText = $sqlStatement.Trim().TrimEnd("GO")
                $SqlCmd.Connection = $conn
                $SqlCmd.CommandTimeout = 600;
        
                if (![string]::IsNullOrWhiteSpace($SqlCmd.CommandText)) {
                    try {
                        $SqlCmd.ExecuteNonQuery();
                    }
                    finally {
                        $SqlCmd.Dispose();
                    }
                }
                else {
                    $SqlCmd.Dispose();
                }
            }
        }

        $conn.Close();
        $conn.Dispose();
    }

    [void]DeployDatabaseSchema()
    {
        if (!$(Test-Path "$PSScriptRoot\ServiceHealthSync\host.json"))
        {
            Expand-Archive -Path "$PSScriptRoot\Sync.zip" -DestinationPath "$PSScriptRoot\ServiceHealthSync"
        }

        Invoke-Expression -Command ". '$PSScriptRoot\DeployDBSchema.ps1' -ApplicationId '$($this.AppId)' -ClientSecret '$($this.ClientSecret)' -TenantDomain '$($this.TenantId)' -DatabaseServer '$($this.DBServerName)' -DatabaseName '$($this.DatabaseName)'"
    }

    [void]DeployAzureFunctionContent()
    {
        Publish-AzWebApp -ResourceGroupName $this.ResourceGroup -Name $this.FunctionAppName -ArchivePath $(Join-Path $PSScriptRoot "Sync.zip") -Force
    }

    [void]DeployAppServiceContent()
    {
        Publish-AzWebApp -ResourceGroupName $this.ResourceGroup -Name $this.WebAppName -ArchivePath $(Join-Path $PSScriptRoot "Hub.zip") -Force
    }

    [void]Run()
    {
        Write-Host "Service Health Hub Deployment"
        Write-Host "============================="
        Write-Host ""
        
        Write-Host "Step 1/6: Creating Azure AD App Registration"
        $this.DeployAzureADAppRegistration();

        Write-Host "Step 2/6: Deploying Azure Resources"
        $this.DeployAzureResources();

        Write-Host "Step 3/6: Configuring SQL database permissions"
        $this.ConfigureSqlDatabasePermissions();

        Write-Host "Step 4/6: Deploying database schema"
        $this.DeployDatabaseSchema();

        Write-Host "Step 5/6: Deploying Azure Function content"
        $this.DeployAzureFunctionContent();

        Write-Host "Step 6/6: Deploying App Service content"
        $this.DeployAppServiceContent();
    }
}