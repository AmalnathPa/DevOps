function WriteParameterFileVNETDeployment{

    Param (

        [Parameter(Mandatory = $True)]
        [String]$parameterFile,

        [Parameter(Mandatory = $True)]
        [String]$outputFile,

        [Parameter(Mandatory = $True)]
        [String]$vnetName,

        [Parameter(Mandatory = $True)]
        [String]$location,

        [Parameter(Mandatory = $True)]
        [String]$vnetAddressPrefix,

        [Parameter(Mandatory = $True)]
        [Int]$noofSubnets,

        [Parameter(Mandatory = $True)]
        [Object]$dnsServers,

        [Parameter(Mandatory = $True)]
        [Object]$subnets

    )

    Begin {

        $paramFileContent = Get-Content $parameterFile -Raw | ConvertFrom-Json
        $parameters = $paramFileContent | Get-Member -MemberType NoteProperty | Where-Object {$_.Name -eq "parameters"}

    }

    Process {

        $paramFileContent.parameters[0].vnetName.value = $vnetName
        $paramFileContent.parameters[0].location.value = $location
        $paramFileContent.parameters[0].vnetAddressPrefix.value = $vnetAddressPrefix
        $paramFileContent.parameters[0].noofSubnets.value = $noofSubnets
        $paramFileContent.parameters[0].dnsServers.value = $dnsServers


        foreach($subnet in $subnets){
            $paramFileContent.parameters[0].subnets.value.subnets += New-Object -TypeName psobject -Property @{name=$subnet.Name; vnetAddressPrefix=$subnet.vnetAddressPrefix}
        }

        $paramFileContent | ConvertTo-Json -Depth 100 | Out-File -Encoding default -FilePath $outputFile


    }

}