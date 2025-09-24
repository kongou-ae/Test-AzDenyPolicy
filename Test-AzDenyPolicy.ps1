$ErrorActionPreference = "Stop"

function Test-AzDenyPolicy {
    param (
        [parameter(mandatory=$true)][string]$resourceBicepPath,
        [parameter(mandatory=$true)][string]$subscriptionId,
        [parameter(mandatory=$true)][string]$resourceGroupName
    )

    $cmd = "bicep build $resourceBicepPath --stdout"
    $templateJson = Invoke-Expression $cmd | Out-String
    $deploymentName = (New-Guid).Guid
    $url = "https://management.azure.com/subscriptions/$subscriptionId/resourcegroups/$resourceGroupName/providers/Microsoft.Resources/deployments/$deploymentName/validate?api-version=2025-04-01"

    $payload = @{
        properties = @{
            mode     = "Incremental"
            template = (ConvertFrom-Json $templateJson)
        }
    } | ConvertTo-Json -Depth 10

    $result = Invoke-AzRestMethod -Uri $url -Method Post -Payload $payload

    $policies = new-object System.Collections.Generic.List[string]
    foreach ($policyDefinitionName in ($result.Content | Convertfrom-Json).error.details.additionalInfo.info.policyDefinitionName) {
        $policies.Add($policyDefinitionName)
    }
    
    $value = [PSCustomObject]@{
        StatusCode = $result.StatusCode
        Message = ($result.Content | Convertfrom-Json).error.message
        Policies = $policies
        Details = ($result.Content | Convertfrom-Json).error.details
    }
    
    return $value
}
