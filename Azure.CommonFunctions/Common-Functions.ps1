function NewResourceGroup{

    Param (

        [Parameter(Mandatory = $True)]
        [String]$rgName,

        [Parameter(Mandatory = $True)]
        [String]$location,

        [Parameter(Mandatory = $True)]
        [String]$subscriptionName

    )

    Begin {

        Select-AzSubscription -SubscriptionName $subscriptionName

    }

    Process {

        $rgList = (Get-AzResourceGroup).ResourceGroupName

        if($rgName -in $rgList) {
            Write-Verbose "The Resource Group already exists"
            }else{
            New-AzResourceGroup -Name $rgName -Location $location
        }
    }
}




function NewARMDeployment{

    Param (

        [Parameter(Mandatory = $True)]
        [String]$rgName,

        [Parameter(Mandatory = $True)]
        [String]$templateFile,

        [Parameter(Mandatory = $True)]
        [String]$parameterFile,

        [Parameter(Mandatory = $True)]
        [String]$deploymentName,

        [Parameter(Mandatory = $True)]
        [String]$subscriptionName

    )

    Begin {

        Select-AzSubscription -SubscriptionName $subscriptionName

    }

    Process {

        New-AzResourceGroupDeployment -Name $deploymentName -ResourceGroupName $rgName -TemplateFile $templateFile -TemplateParameterFile $parameterFile -Mode Incremental -Verbose
    }

}