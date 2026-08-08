using module ../ServiceHealthSync/Modules/AuthManager.psm1

param(
    [string]$OrganizationUri,
    [string]$ClientId,
    [string]$ClientSecret,
    [string]$TenantDomain
)
$OrganizationUri = $OrganizationUri.Trim().TrimEnd("/");

$authMgr = [AuthManager]::new($ClientId, $ClientSecret, $TenantDomain, "499b84ac-1321-427f-aa17-267ca6975798")
$header = @{
    Authorization = [string]::Format("{0} {1}", $authMgr.Token.token_type, $authMgr.Token.access_token)               
}
$processList = Invoke-RestMethod -Method GET -Uri "$OrganizationUri/_apis/process/processes?api-version=7.1-preview.1" -Headers $header
$scrumProcess = $processList.value | Where-Object name -eq Scrum
$createProcessBody = @{
    name = "Service Health Hub"
    parentProcessTypeId = $scrumProcess.id
    description = ""                             
};
$newProcess = Invoke-RestMethod -Method Post -Uri "$OrganizationUri/_apis/work/processes?api-version=7.1-preview.2" -Body $(ConvertTo-Json $createProcessBody -Depth 10) -Headers $header -ContentType "application/json"

$createFieldUri = $OrganizationUri + "/_apis/work/processdefinitions/$($newProcess.typeId)/fields?api-version=4.1-preview.1"
Write-Host "Creating fields";

$adoFields = Get-Content $(Join-Path -Path $PSScriptRoot -ChildPath 'adoFieldDefinitions.json') | ConvertFrom-Json -Depth 5
$fields = @()
foreach ($field in $adoFields)
{
    Write-Host "Adding field $($field.name)"                                                    
    $r = Invoke-RestMethod -Method Post -Uri $createFieldUri -Body $(ConvertTo-Json $field -Depth 5) -Headers $header -ContentType "application/json"
    $fields += $r
}


$witDefinitions = Get-Content $(Join-Path -Path $PSScriptRoot -ChildPath 'witDefinitions.json') | ConvertFrom-Json -Depth 10
$createWitUri = $OrganizationUri + "/_apis/work/processdefinitions/$($newProcess.typeId)/workitemtypes?api-version=4.1-preview.1"

foreach ($definition in $witDefinitions)
{
    Write-Host "Creating work item type $($definition.name)"
    $workItemType= Invoke-RestMethod -Method POST -Uri $createWitUri -Headers $header -ContentType "application/json" -Body $(ConvertTo-Json $definition.definition -Depth 10)

    Write-Host "`tAdding fields to work item type $($definition.name)"
    $addFieldUri = $workItemType.url+"/fields?api-version=6.0-preview.1"
    foreach ($fieldDef in $definition.fields)
    {
        Write-Host "`t`tAdding field $($fieldDef.referenceName)"
        $field = Invoke-RestMethod -Method Post -Uri $addFieldUri -Headers $header -ContentType "application/json" -Body $(ConvertTo-Json $fieldDef -Depth 10)
    }

    Write-Host "`tCreating layout for work item type $($definition.name)"
    foreach ($sectionDef in $definition.sections)
    {
        Write-Host "`t`tAdding groups to the section $($sectionDef.name)"
        $addGroupUri = $workItemType.url + "/layout/pages/d0171d51-ff84-4038-afc1-8800ab613160.System.WorkItemType.Details/sections/$($sectionDef.name)/groups?api-version=6.0-preview.1"
        foreach ($groupDef in $sectionDef.groups)
        {
            Write-Host "`t`t`tAdding group $($groupDef.label)"
            $group = Invoke-RestMethod -Method Post -Uri $addGroupUri -Headers $header -Body $(ConvertTo-Json $groupDef -Depth 10) -ContentType "application/json"
        }
    }

    Write-Host "`tPerforming cleanup for work item type $($definition.name)"
    $cleanupRootUri = $OrganizationUri + "/_apis/work/processes/" + $workItemType.url.TrimStart($OrganizationUri+"/_apis/work/processDefinitions/")
    foreach ($groupDef in $definition.hideGroups)
    {
        Write-Host "`t`tHiding group $($groupDef.name)"
        $res = Invoke-RestMethod -Method PATCH -Uri "$cleanupRootUri/layout/groups/$($groupDef.name)?api-version=6.0-preview.1" -Headers $header -Body $(ConvertTo-Json $groupDef.payload -Depth 10) -ContentType "application/json"
    }
}

