BeforeAll {
    . $PSScriptRoot/Test-AzDenyPolicy.ps1
    $resourceGroupName = "rg-policy-test"
    $subscriptionId = (Get-AzContext).Subscription.Id
}

Describe 'Test GPU VM Creation' {

    Context 'Deny NV8as VM Creation' {
        BeforeAll {
            $resourceBicepPath = ".\test\deny_Standard_NV8as_v4.bicep"
            $result = Test-AzDenyPolicy -resourceBicepPath $resourceBicepPath -subscriptionId $subscriptionId -resourceGroupName $resourceGroupName
        }
        It 'return code is 400' {
            $result.StatusCode | Should -Be 400
        }

        It 'error message contains policy violation' {
            $result.Message | Should -Be "The template deployment failed because of policy violation. Please see details for more information."
        }

        It 'policy name is deny-expensive-gpu-vm' {
            $result.Policies | Should -Contain "deny-expensive-gpu-vm"
        }
    }

    Context 'Allow NV4as VM Creation' {
        BeforeAll {
            $resourceBicepPath = ".\test\Allow_Standard_NV4as_v4.bicep"
            $result = Test-AzDenyPolicy -resourceBicepPath $resourceBicepPath -subscriptionId $subscriptionId -resourceGroupName $resourceGroupName
        }
        It 'return code is 200' {
            $result.StatusCode | Should -Be 200
        }
    }
}