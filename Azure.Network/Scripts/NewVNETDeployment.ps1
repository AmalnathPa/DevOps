

function NewVNETDeployment {

    Param (

        [Parameter(Mandatory = $True)]
        [String]$rootPath,

        [Parameter(Mandatory = $True)]
        [String]$env

    )

    Begin {

        $envParamRootPath = Join-Path `
                        -Path $rootPath `
                        -ChildPath "\Network\ParameterMap\$env\"

        $mapFilePath = Join-Path `
                        -Path $envParamRootPath `
                        -ChildPath "\vnet-map.json"

        $armTemplatePath = Join-Path `
                        -Path $rootPath `
                        -ChildPath "\Network\ARMTemplatesGeneric\arm_deploy_vnet.json"


        $parameterFilePath = Join-Path `
                        -Path $envParamRootPath `
                        -ChildPath "\ARM_Parameter_Files\"

        $inputVariables = (Get-Content -Path $mapFilePath) | ConvertFrom-Json


        $envInputVariable = $inputVariables | Where-Object {$_.Env -eq $env}


    }

    Process {

        foreach($vnet in $envInputVariable.vnet){
            $rgName = ($envInputVariable | Where-Object {$_.vnet -eq $vnet}).rgName
            $subscriptionName = ($envInputVariable | Where-Object {$_.vnet -eq $vnet}).subscription
            $location = ($envInputVariable | Where-Object {$_.vnet -eq $vnet}).location

            $parameterFile = Join-Path `
                                -Path $parameterFilePath `
                                -ChildPath "arm_param_vnet_$vnet.json"

            $deploymentName = "Deployment"+$vnet


            NewResourceGroup -rgName $rgName -location $location -subscriptionName $subscriptionName

            NewARMDeployment -rgName $rgName -templateFile $armTemplatePath -parameterFile -$parameterFile -deploymentName $deploymentName -subscriptionName $subscriptionName



        }

    }

}