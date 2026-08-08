## Create an Azure DevOps process

Microsoft Service Health Hub delivers detailed information in the form of metadata. This metadata can be used to generate reports and dashboards that provide better insights into events occurring within the tenant.

Dashboards may target a specific product that is relevant for a specific team within your organization. Reports may provide high-level information about incidents within the tenant for management.

To bring in the custom metadata, you need to create an Azure DevOps process that contains multiple work item types. Work item types allow you to:

- add or modify fields,
- add or modify field rules,
- change the workflow,
- customize the work item form.

Out-of-the-box processes cannot be modified directly. Therefore, you first need to create an inherited process based on one of the out-of-the-box processes and then add work item types to the custom process.

This process is fully automated. However, the service principal, which is the app registration created during deployment, must have permission to perform the operation.

### Add the service principal to Azure DevOps

1. Start the browser, sign in to Azure DevOps, and select your organization:

   <https://go.microsoft.com/fwlink/?LinkId=307137>

   If you do not have an Azure DevOps organization yet, create one by following the instructions here:

   <https://learn.microsoft.com/en-us/azure/devops/organizations/accounts/create-organization?view=azure-devops>

2. Go to **Organization settings** in the lower-left corner of the page.

3. Under **General**, select **Users**.

4. Select **Add users**.

5. In the **Users or Service Principals** text box, enter either the service principal name or the application client ID:

   - Name: `$deployment.AppName`
   - Application client ID: `$deployment.AppId`

6. Select the service principal.

7. Set **Access level** to **Basic**.

8. Select **Add**.

This adds the service principal to the Azure DevOps organization and assigns a license to it.

### Assign temporary permissions

Assign temporary permissions for the deployment.

1. Under **Security**, select **Permissions**.

2. Select **Project Collection Administrators**.

3. On the **Members** tab, select **Add**.

4. Search for the service principal by using either:

   - the service principal name
   - the application client ID

5. Select the service principal.

6. Select **Save**.

### Deploy the Azure DevOps process

Return to the PowerShell console from the **Run the deployment script** section.

Run the following commands:

```powershell
cd '.\Azure-DevOps-Mapping\'

.\Deploy-ADOProcess.ps1 `
    -OrganizationUri "https://dev.azure.com/{insert your organization URI here}" `
    -ClientId $deployment.AppId `
    -ClientSecret $deployment.ClientSecret `
    -TenantDomain $deployment.TenantId
```

### Remove temporary permissions

After the process deployment is complete, remove the temporary permissions.

1. Under **Security**, select **Permissions**.

2. Select **Project Collection Administrators**.

3. On the **Members** tab, select the service principal.

4. Select **Remove**.

---

**Previous:** [Create an Azure DevOps process](./create-azure-devops-process.md)

**Next:** [Create an Azure DevOps project](./create-azure-devops-project.md)