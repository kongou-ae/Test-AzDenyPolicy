BeforeAll {
    . $PSScriptRoot/Test-AzDenyPolicy.ps1
    $resourceGroupName = "rg-policy-test"
    $subscriptionId = (Get-AzContext).Subscription.Id
}


Describe 'Test Azure Policy Deny' {

    Context 'Deny VNet Creation' {
        BeforeAll {
            $resourceBicepPath = ".\test\deny_vnet.bicep"
            $result = Test-AzDenyPolicy -resourceBicepPath $resourceBicepPath -subscriptionId $subscriptionId -resourceGroupName $resourceGroupName
        }
        It 'return code is 400' {
            $result.StatusCode | Should -Be 400
        }

        It 'error message contains policy violation' {
            $result.Message | Should -Be "The template deployment failed because of policy violation. Please see details for more information."
        }

        It 'policy name is deny-vnet-creation' {
            $result.Policies | Should -Contain "deny-vnet-creati"
        }
        
    }
}