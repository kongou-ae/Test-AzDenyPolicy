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
invoke-pester .\ValidateAzPolicy.test.ps1 -Output Detailed
Pester v5.7.1

Starting discovery in 1 files.
Discovery found 4 tests in 208ms.
Running tests.

Running tests from 'C:\Users\username\source\repos\Test-AzDenyPolicy\ValidateAzPolicy.test.ps1'
Describing Test GPU VM Creation
 Context Deny NV8as VM Creation
   [+] return code is 400 40ms (35ms|5ms)
   [+] error message contains policy violation 43ms (41ms|2ms)
   [+] policy name is deny-expensive-gpu-vm 35ms (34ms|1ms)
 Context Allow NV4as VM Creation
   [+] return code is 200 45ms (42ms|3ms)
Tests completed in 14.03s
Tests Passed: 4, Failed: 0, Skipped: 0, Inconclusive: 0, NotRun: 0
```
