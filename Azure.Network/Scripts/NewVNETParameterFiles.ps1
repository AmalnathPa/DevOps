function NewVNETParameterFiles{

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

        $armParameterTemplatePath = Join-Path `
                        -Path $rootPath `
                        -ChildPath "\Network\ARMTemplatesGeneric\arm_param_vnet.json"


        $parameterOutputFilePath = Join-Path `
                        -Path $envParamRootPath `
                        -ChildPath "\ARM_Parameter_Files\"

        $inputVariables = (Get-Content -Path $mapFilePath) | ConvertFrom-Json


        $envInputVariable = $inputVariables | Where-Object {$_.Env -eq $env}


    }

    Process {

        foreach($vnet in $envInputVariable.vnet){
            $vnetName = $vnet
            $location = ($envInputVariable | Where-Object {$_.vnet -eq $vnet}).location
            $vnetAddressPrefix = ($envInputVariable | Where-Object {$_.vnet -eq $vnet}).addressprefix
            $noofSubnets = ($envInputVariable | Where-Object {$_.vnet -eq $vnet}).noofSubnets
            $subscription = ($envInputVariable | Where-Object {$_.vnet -eq $vnet}).subscription
            $dnsServers = ($envInputVariable | Where-Object {$_.vnet -eq $vnet}).dnsServers
            $subnets = ($envInputVariable | Where-Object {$_.vnet -eq $vnet}).subnets

            $parameterOutputFile = Join-Path `
                                -Path $parameterOutputFilePath `
                                -ChildPath "arm_param_vnet_$vnet.json"

            WriteParameterFileVNETDeployment -parameterFile $armParameterTemplatePath -outputFile $parameterOutputFile `
                                            -vnetName $vnet -location $location `
                                            -vnetAddressPrefix $vnetAddressPrefix -dnsServers $dnsServers `
                                            -noofSubnets $noofSubnets -subnets $subscription

        }

    }

}