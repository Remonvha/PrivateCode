# Sample usage

param(
    [Parameter(Mandatory=$true)]$mgId, 
    [Parameter(Mandatory=$true)]$blueprintName,
    [Parameter(Mandatory=$true)]$spnId,
    [Parameter(Mandatory=$true)]$spnPass,
    [Parameter(Mandatory=$true)]$tenantId,
    [Parameter(Mandatory=$true)]$parametersPath,
    [Parameter(Mandatory=$true)]$subscriptionId,
    [Parameter(Mandatory=$true)]$VersionId
)

# Output powershell version for debugging purposes and is probably generally good to know
$PSVersionTable.PSVersion # Assuming powershell core (6)

if (!(Get-Module -ListAvailable -Name Az.Blueprint)) {
    Write-Host "Installing Az module"
    Install-Module -Name Az.Blueprint -AllowClobber -Force
} else
{
    Write-Host "Az.Blueprint module already exists"
}

Write-Host "Start login with SPN"
$pass = ConvertTo-SecureString $spnPass -AsPlainText -Force
$cred = New-Object -TypeName pscredential -ArgumentList $spnId, $pass
Login-AzAccount -Credential $cred -ServicePrincipal -TenantId $tenantId

Write-Host "Azure context:"
Get-AzContext

$latestPublishedBp = Get-AzBlueprint -ManagementGroupId $mgId -Name $blueprintName -LatestPublished

# Auto-inserts blueprintId into parameters file
$content = Get-Content $parametersPath -raw | ConvertFrom-Json
$content.properties | % {if($_.blueprintId -ne $latestPublishedBp.id){$_.blueprintId=$latestPublishedBp.id}}
$content | ConvertTo-Json -Depth 100| set-content $parametersPath

## Check for existing blueprint assignment)
Write-Host "retrieve existing blueprint"
$existingBp = Get-AzBlueprintAssignment -Name "pla-$blueprintName" -subscriptionId $subscriptionId -ErrorAction SilentlyContinue

Write-Host $existingBp

if ($existingBp) {
    Write-Host "Blueprint already exists updating assignment"
    Set-AzBlueprintAssignment -Name "pla-$blueprintName" -Blueprint $latestPublishedBp -AssignmentFile $parametersPath -SubscriptionId $subscriptionId 
} else {
    Write-Host "No existing blueprint assignment. Creating one..."
    New-AzBlueprintAssignment -Name "pla-$blueprintName" -Blueprint $latestPublishedBp -AssignmentFile $parametersPath -SubscriptionId $subscriptionId
} 

# Wait for assignment to complete
$timeout = new-timespan -Seconds 500
$sw = [diagnostics.stopwatch]::StartNew()

while (($sw.elapsed -lt $timeout) -and ($AssignemntStatus.ProvisioningState -ne "Succeeded") -and ($AssignemntStatus.ProvisioningState -ne "Failed")) {
    $AssignemntStatus = Get-AzBlueprintAssignment -Name "pla-$blueprintName" -SubscriptionId $subscriptionId
    if ($AssignemntStatus.ProvisioningState -eq "failed") {
        Throw "Assignment Failed. See Azure Portal for details."
        break
    }
}

if ($AssignemntStatus.ProvisioningState -ne "Succeeded") {
    Write-Warning "Assignment has timed out, activity is exiting."
}

 Write-Host "Blueprint assignment succeeded."

$VersionId = "$VersionId.release"
$blueprint = Get-AzBlueprint -ManagementGroupId $mgId -Name $blueprintName
if(!$blueprint.id -eq $VersionId){
    Write-Host "publishing release version"
    Publish-AzBlueprint -Blueprint $blueprint -Version $VersionId
    Write-Host "release version published"
}



