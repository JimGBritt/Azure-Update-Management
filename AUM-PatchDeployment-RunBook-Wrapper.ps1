<#PSScriptInfo
.VERSION 1.0
.GUID 58d73006-964b-4cb6-9b36-1dd7eb858338
.AUTHOR manjeet.bavage@microsoft.com
.COMPANYNAME Microsoft
.COPYRIGHT Microsoft
.RELEASENOTES July 27, 2021 1.0
#>

<#

.DESCRIPTION
 Azure Update Management (AUM) runbook wrapper script to automate execution of Create-azUpdatePatchDeploymentList using Azure Automation Runbook.
 Refer to Create-azUpdatePatchDeploymentList at https://www.powershellgallery.com/packages/Create-AzUpdatePatchDeploymentList
 Both Create-azUpdatePatchDeploymentList.ps1 and AUM-PatchDeployment-Runbook-Wrapper.ps1 should be published to the Automation Account Runbooks
 Includes try-catch to notify if AzureRunAsConnection in unavailable.
 Requires Azure Automation modules Az.Accounts, Orchestrator.AssetManagement.Cmdlets, and Az.operationalinsights

 #>
## Get the Azure Automation Acount Information
$connectionName = "AzureRunAsConnection"
try
{
    # Get Azure Automation Account Information
    $azConn = Get-AutomationConnection -Name $connectionName
    ## Add the automation account context to the session
    connect-AzAccount -ServicePrincipal -Tenant $azConn.TenantID -ApplicationId $azConn.ApplicationId -CertificateThumbprint $azConn.CertificateThumbprint
}
catch {
    if (!$azConn)
    {
        $ErrorMessage = "Connection $connectionName not found."
        throw $ErrorMessage
    } else{
        Write-Error -Message $_.Exception
        throw $_.Exception
    }
}
.\Create-azUpdatePatchDeploymentList.ps1 `
		-Force `
		-AAResourceGroupName Automation-Account-Resource-Group `
		-AAAcountName Automation-Account-Name `
		-SoftwareUpdateScheduleName "Linux_Dev_v2"`
		-WeekInterval 4 `
		-WSID Log-Analytics-Workspace-ID `
		-ClassificationList "Critical","Security","Other" `
		-DaysOfWeek "Friday","Saturday" `
		-queryLocation "westus","centralus" `
		-queryFilterOperator "any" `
		-RebootOptions "IfRequired" `
		-TargetOS Linux `
		-duration (New-TimeSpan -Hours 4) `
		-SourceSubscriptionID Source-Subscription-ID `
		-TargetSubscriptionID Target-Subscription-ID