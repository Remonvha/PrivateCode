param(
    [Parameter(Mandatory=$true)]$mgId, 
    [Parameter(Mandatory=$true)]$BlueprintFolder,
    [Parameter(Mandatory=$true)]$blueprintName,
    [Parameter(Mandatory=$true)]$spnId,
    [Parameter(Mandatory=$true)]$spnPass,
    [Parameter(Mandatory=$true)]$tenantId,
    [Parameter(Mandatory=$true)]$VersionId
)

# Output powershell version for debugging purposes and is probably generally good to know
$PSVersionTable.PSVersion # Assuming powershell core (6)

Write-Host "Installing Az module"
Install-Module -Name Az.Blueprint -AllowClobber -Force # todo - check installation status
Write-Host "Successfully installed Az.Blueprint module"


Write-Host "Start login with SPN"
$pass = ConvertTo-SecureString $spnPass -AsPlainText -Force
$cred = New-Object -TypeName pscredential -ArgumentList $spnId, $pass
Login-AzAccount -Credential $cred -ServicePrincipal -TenantId $tenantId
Write-Host "Successfully logged in with SPN"

Write-Host "Azure context:"
Get-AzContext

Write-Host "Start Blueprint import"
Import-AzBlueprintWithArtifact -Name $blueprintName -ManagementGroupId $mgId -InputPath $BlueprintFolder -Force -IncludeSubFolders -PassThru

# success
if ($?) {
    Write-Host "Imported successfully"
    $VersionId = "$VersionId.build"
    $importedBp = Get-AzBlueprint -ManagementGroupId $mgId -Name $blueprintName 
    Publish-AzBlueprint -Blueprint $importedBp -Version $VersionId

    # TODO - Clean up old test version(s)
} else {
    throw "Failed to import successfully"
    exit 1
}