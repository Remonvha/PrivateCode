# Documentation: Azure Blueprints
This document describes creating 'Azure Blueprints', as part of the PitWall.
For more information: [Azure Blueprints]

# Create and update Azure Blueprints via the Azure Portal
In the Azure Portal, go to:
- Blueprints > Blueprint definitions > + Create blueprint > Blank Blueprint
OR
- Blueprints > Getting started > Create [a blueprint] > Blank Blueprint.

Give the new Blueprint a name and define the location [subscription] where it resides. Next: now you can add artifacts to the specified subscription like:
- Policy assignment
- Role assignment
- Azure Resource Manager template[s] (ARM)
- Resource Group

If applicable define a Resource Group:
- Next: Artifacts
- + Add artifact
- Artifact type: Resource Group 
- Set display name [+ resource group name] [+ location]

Next: now you can add artifacts to the specified resource group like:
- Policy assignment
- Role assignment
- Azure Resource Manager template[s] (ARM)

# Create and update Azure Blueprints via CI/CD
# Prerequisites

Before you can start us
ing this sample, you'll need to preparate te following steps:
### 1. Service Connection

Blueprints can be saved to a management Group or Subscription.
Therefore you'll need to setup a service connection to that Management Group / Subscription.
To create a new service connection from Azure DevOps use the following link: [Service Connections]
</br></br>

### 2. Azure AD Permissions for your Azure DevOps Service Principal.
Once created you'll find your service connection in the app registration blade of Azure AD. Next we wil improve the generated name by selecting the service principal and assigining a logical name.
You'll find this in the branding blad of the app registration. This name has to be Unique.
</br></br>
Next up we need to assign  API permission to the service connection (app registration)*:</br>
*This requires admin consent

|API / Permission name | Type | Description
| ------ | ------ |------ |
| Azure Active Directory Graph (1)|       |                                | 
| Application.ReadWrite.All | Application |Read and write all applications |
| Microsoft Graph (1)     |               |                                | 
|Application.ReadWrite.All | Application  |Read and write all applications |

</br>


>NOTE: This application is using Azure AD Graph API, which is on a deprecation path. Starting June 30th, 2020 the development to Azure AD Graph API is stopped.
We still need this Permission since the Az.Blueprint Powershell Module still uses this library. The new Microsoft Graph API Permission is also added to ensure smooth transition.

# Implementing Azure Blueprints
In the Blueprints folder you'll find the following folders:

1. blueprint
2. pipelines
3. additional artifacts

### Blueprint folder
The Azure Blueprint consists out of 3 parts which are needed to deploy the blueprint:

1. Blueprint definition (blueprint.json)
2. Blueprint artifacts  (Artifacts folder) => currently: policies, roles, storage and log analytics workspace
3. Blueprint assignment (blueprintAssignment-{env}.json)

The blueprint definition consists of paramaters and resource groups your blueprint contains. Actually it's similar to a orchestrator for ARM. Everything in the Artifact folder is automatically added to your blueprint when its being created in the portal.

>If you would like to add more artifacts, you can add them in the artifacts folder before deployment. New parameters need to be included in the blueprint definition and assignment.

Last but not least the blueprint assignment, this is the parameter file for a specific blueprint assignment. </br></br>

# Deploying the Blueprint solution

The pipelines folder contains the "blueprint specific" build and release stages. In order to make the pipeline complete, you need to make the correct path reference to your generic template step folder. 

Make sure this folder contains atleast the following steps:

- azure-service-principal-create.yml
- azure-service-principal-remove.yml
- azure-blueprint-build.yml with powershell script
- azure-blueprint-release.yml with powershell script
- publish-artifact.yml

Once these templates steps are included and the reference is set, you'll be go to go.
</br></br>

# To Do
- [ ] Add ARM for environment specific resource groups and tags.


[Azure Blueprints]: https://docs.microsoft.com/en-us/azure/governance/blueprints/overview

[Service Connections]: https://docs.microsoft.com/en-us/azure/devops/pipelines/library/service-endpoints?view=azure-devops&tabs=yaml