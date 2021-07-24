<#PSScriptInfo
.VERSION 1.0
.AUTHOR manjeet.bavage@microsoft.com
.COMPANYNAME Microsoft
.COPYRIGHT Microsoft
.RELEASENOTES
July 12, 2021 1.0
    Azure Update Management (AUM) runbook wrapper script to execute Create-azUpdatePatchDeploymentList.ps1 using Azure Automation Runbook.
    Refer to Create-azUpdatePatchDeploymentList.ps1 https://www.powershellgallery.com/packages/Create-AzUpdatePatchDeploymentList  
#>
## Get the Azure Automation Acount Information
$azConn = Get-AutomationConnection -Name 'AzureRunAsConnection'
## Add the automation account context to the session
connect-AzAccount -ServicePrincipal -Tenant $azConn.TenantID -ApplicationId $azConn.ApplicationId -CertificateThumbprint $azConn.CertificateThumbprint
.\Create-azUpdatePatchDeploymentList.ps1 `
		-Force `
		-AAResourceGroupName <Automation Account Resource Group> `
		-AAAcountName <Automation Account Name> `
		-SoftwareUpdateScheduleName "Linux_Dev"`
		-WeekInterval 4 `
		-WSID <Log Analytics Workspace ID> `
		-ClassificationList "Critical","Security","Other" `
		-DaysOfWeek "Friday","Saturday" `
		-queryLocation "westus","centralus" `
		-queryFilterOperator "any" `
		-RebootOptions "IfRequired" `
		-TargetOS Linux `
		-duration (New-TimeSpan -Hours 4) `
		-SourceSubscriptionID <Source Subscription ID> `
		-TargetSubscriptionID <Target Subscription ID>