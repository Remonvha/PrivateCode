# Documentation
This document explains how to preserve already configured key vault access policies, after an incremental [re]deployment of a key vault instance.

Currently Key Vault redeployment deletes any access policy in Key Vault and replace them with access policy in ARM template. 
There is no incremental option for Key Vault access policies. To preserve access policies in Key Vault, you need to read existing 
access policies in Key Vault and populate ARM template with those policies to avoid any access outages.
https://docs.microsoft.com/en-us/azure/key-vault/general/troubleshooting-access-issues

Another option that can help for this scenario is using RBAC roles as an alternative to access policies. 
With RBAC, you can re-deploy the key vault without specifying the policy again.
https://docs.microsoft.com/en-us/azure/key-vault/general/rbac-guide

# PowerShell
You can use a PowerShell script to read existing access policies in Key Vault. 
The script is located here: arm > key-vault > scripts > GetKeyVaultAccessPolicies.ps1

# YAML
Via the YAML release step, the PowerShell script can be run and subsequently the output [list of exsiting access polices] 
can be assigned to the orchestrator/ARM template as type object. The YAML is located here: yaml > pipeline > stages > steps > azure-resource-group-deployment-orchestrated-release-preserve-key-vault-access-policies.yml

# ARM
Via the orchestrator, the output [list of exsiting access polices] can be assigned to [and used by] the key vault ARM template as type object.

"accessPolicies": {
      "defaultValue": { "list": [] },
      "type": "object"
    }

"accessPolicies": "[parameters('accessPolicies').list]"

# Sources 
https://docs.microsoft.com/en-us/azure/key-vault/general/troubleshooting-access-issues
https://yourazurecoach.com/2018/11/13/key-vault-deployment-removes-access-policies/
https://docs.microsoft.com/en-us/azure/key-vault/general/rbac-guide
