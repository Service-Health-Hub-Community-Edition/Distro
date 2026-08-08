using module ".\ServiceHealthSync\Modules\AuthManager.psm1"
using module ".\ServiceHealthSync\Modules\M365ServiceHealthHubDB.psm1"

param(
    [string]$ApplicationId,
    [string]$ClientSecret,
    [string]$TenantDomain,
    [string]$DatabaseServer,
    [string]$DatabaseName
)

function Add-Image([string]$Name, [string]$Type, [string]$Url, [M365ServiceHealthHubDB] $db)
{
    $Url = $Url.Trim();
    
    if (!($Url.EndsWith(".png") -or $Url.EndsWith(".jpg") -or $Url.EndsWith(".jpeg") -or $Url.EndsWith(".gif")))
    {
        throw "Image format is not supported. Supported image formats are PNG, JPEG and GIF";
    }

    $extension = $Url.Substring($Url.LastIndexOf("."));
    $format = "";
    switch ($extension)
    {
        ".png" { $format = "image/png" }
        ".gif" { $format = "image/gif" }
        ".jpg" { $format = "image/jpeg" }
        ".jpeg" { $format = "image/jpeg" }
    }

    $response = Invoke-WebRequest $Url;

    $content = "";

    if ($response.BaseResponse.IsSuccessStatusCode)
    {
        $content = [Convert]::ToBase64String($response.Content);

    }

    $db.AddImage($Name, $Type, $format, $content);
}

Write-Host "Obtaining token"
Write-Host "Application ID: $ApplicationId - ClientSecret: $ClientSecret - Tenant ID: $TenantDomain"
$authMgr = [AuthManager]::new($ApplicationId, $ClientSecret, $TenantDomain, "https://database.windows.net")

Write-Host $authMgr.Token.access_token
$connStr = "Data Source=$DatabaseServer.database.windows.net;Initial Catalog=$DatabaseName;Encrypt=True;"
$db = [M365ServiceHealthHubDB]::new($connStr, $authMgr)
$db.PerformSchemaCheck($true);

$imageStoreVersionTimestamp = $db.GetConfigValue("ImageStoreVersionTimestamp")

if ($null -eq $imageStoreVersionTimestamp)
{
    $imageStoreVersionTimestamp = [DateTime]::MinValue
}

$imageStoreUpdates = Invoke-RestMethod https://servicehealthhub.blob.core.windows.net/imagestore/store.json
$imageStoreUpdates = $imageStoreUpdates | Sort-Object published
$latestVersion = $imageStoreUpdates | Select-Object -ExpandProperty published -Last 1

$latestUpdateTimestamp = $imageStoreVersionTimestamp

foreach ($update in $imageStoreUpdates)
{
    if ($update.published -gt $imageStoreVersionTimestamp)
    {
        foreach ($image in $update.add)
        {
            Write-Host "Adding image $($image.Name) | $($image.Type) | $($image.Url).";                                 
            Add-Image -Name $image.Name -Type $image.Type -Url $image.Url -db $db
        }

        $latestUpdateTimestamp = $update.published
    }
}

$db.SetConfigValue("ImageStoreVersionTimestamp", $latestUpdateTimestamp)