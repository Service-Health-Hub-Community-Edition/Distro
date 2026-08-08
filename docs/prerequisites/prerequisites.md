# Prerequisites

Before deploying Microsoft Service Health Hub, ensure that all prerequisites in this section are met.

## Local Computer Requirements

- A **Windows** or **macOS** computer connected directly to the internet.
- The computer must **not** use a proxy server.

> Some deployment steps, particularly database permission configuration and database schema deployment, do not work through a proxy.

## PowerShell 7

Install **PowerShell 7 Core**.

For installation instructions, see:

https://learn.microsoft.com/en-us/powershell/scripting/install/installing-powershell

Enable PowerShell script execution for the current process:

```powershell
Set-ExecutionPolicy -ExecutionPolicy Unrestricted -Scope Process
```

## Microsoft Graph PowerShell SDK

Install the **Microsoft Graph PowerShell SDK** modules.

For installation instructions, see:

[Install Microsoft Graph PowerShell SDK](https://learn.microsoft.com/en-us/powershell/microsoftgraph/installation)

## Azure PowerShell

Install the **Azure PowerShell** modules.

For installation instructions, see:

[Install Azure PowerShell](https://learn.microsoft.com/en-us/powershell/azure/install-azure-powershell)

### Required Module Versions

| Module | Required Version |
|----------|----------|
| Az.Websites | 2.8.0 |
| Az.Resources | 4.4.0 |
| Az.Accounts | 2.12.1 |

> Newer versions of these modules, and the DLLs installed with them, may cause compatibility issues with the Microsoft Graph PowerShell SDK. Ensure that only the versions listed above are installed on the deployment workstation.

## Bicep Command-Line Tool

Install the **Bicep command-line tool**.

For installation instructions, see:

[Install Bicep](https://learn.microsoft.com/en-us/azure/azure-resource-manager/bicep/install)

## Azure Subscription and Resource Group

You need:

- An **Azure subscription**
- An **Azure resource group** where Microsoft Service Health Hub resources will be deployed

For instructions on creating resource groups, see:

[Create Resource Groups](https://learn.microsoft.com/en-us/azure/azure-resource-manager/management/manage-resource-groups-portal#create-resource-groups)

> The Azure subscription must provide external internet connectivity.

## Azure DevOps

You need:

- An **Azure DevOps project**
- An account with **Project Administrator** permissions for that project

## Required Permissions and Roles

### Microsoft Entra ID Role

The deployment account must have one of the following roles in the Microsoft Entra tenant:

- **Global Administrator**
- **Privileged Role Administrator**

For more information, see:

[Grant Admin Consent](https://learn.microsoft.com/en-us/entra/identity/enterprise-apps/grant-admin-consent)

### Azure Resource Group Permissions

The deployment account must have the **Owner** role assigned to the target resource group.

For instructions on assigning permissions, see:

[Assign Azure RBAC Roles](https://learn.microsoft.com/en-us/azure/role-based-access-control/role-assignments-portal)

### Cognitive Services Permissions

The deployment account must have the **Cognitive Services Contributor** role on the Azure subscription to accept the Responsible Use of AI terms during deployment.

For more information, see:

[Cognitive Services Contributor Role](https://learn.microsoft.com/en-us/azure/role-based-access-control/built-in-roles/ai-machine-learning#cognitive-services-contributor)

---

**Previous:** [Start](../README.md)

**Next:** [Run the deployment script](../deployment/resource-deployment.md)