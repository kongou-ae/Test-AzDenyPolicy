# Test-AzDenyPolicy

This function returns a simple result of [Deployments - Validate](https://learn.microsoft.com/en-us/rest/api/resources/deployments/validate?view=rest-resources-2025-04-01&tabs=HTTP)

## Usage

```powershell
Import-module .\Test-AzDenyPolicy.ps1
Test-AzDenyPolicy -resourceBicepPath .\test\deny_vnet.bicep -resourceGroupName rg-policy-test -subscriptionId ((Get-AzContext).Subscription.Id) | fl *

StatusCode : 400
Message    : The template deployment failed because of policy violation. Please see details for more information.
Policies   : {deny-vnet-creation, deny-vnet-creation2}
```

You can use this function with Pester. The sample is [ValidateAzPolicy.test.ps1](./ValidateAzPolicy.test.ps1)

```powershell
 Invoke-pester .\ValidateAzPolicy.test.ps1 -Output Detailed                                             
Pester v5.7.1                                  

Starting discovery in 1 files.
Discovery found 3 tests in 33ms.
Running tests.

Running tests from 'C:\Users\UserName\source\repos\Test-AzDenyPolicy\ValidateAzPolicy.test.ps1'
C:\Users\UserName\source\repos\Test-AzDenyPolicy\test\deny_vnet.bicep(3,13) : Warning no-hardcoded-location: A resource location should not use a hard-coded string or variable value. Please use a parameter value, an expression, or the string 'global'. Found: 'japaneast' [https://aka.ms/bicep/linter/no-hardcoded-location]
Describing Test Azure Policy Deny
 Context Deny VNet Creation
   [+] return code is 400 7ms (2ms|5ms)
   [+] error message contains policy violation 3ms (2ms|1ms)
   [-] policy name is deny-vnet-creation 9ms (7ms|1ms)
    Expected 'deny-vnet-creati' to be found in collection @('deny-vnet-creation', 'deny-vnet-creation2'), but it was not found.
    at $result.Policies | Should -Contain "deny-vnet-creati", C:\Users\UserName\source\repos\Test-AzDenyPolicy\ValidateAzPolicy.test.ps1:24
    at <ScriptBlock>, C:\Users\UserName\source\repos\Test-AzDenyPolicy\ValidateAzPolicy.test.ps1:24
Tests completed in 6s
Tests Passed: 2, Failed: 1, Skipped: 0, Inconclusive: 0, NotRun: 0
```
