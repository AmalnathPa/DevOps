<#
====================================================================
File: Infra-Common.psm1

Purpose: For all common functions used for Infrastructure Deployment

====================================================================
#>



. $PSScriptRoot\Common-Functions.ps1


# Resource Group Deployment
Export-ModuleMember -Function "NewResourceGroup"

# ARM Deployment
Export-ModuleMember -Function "NewARMDeployment"