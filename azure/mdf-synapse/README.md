<!-- ABOUT THE PROJECT -->
# About The Project

All knowledge of synapse implementations combined in one solution accelerator

Benefits:

* Quick start of a project on Synapse
* Based on Data & Analytics best practices

## Services used

MDF Consists of the following components

| Service                   | Purpose                           | Remarks           |
| -------------             | -------------                     | ----------        |
| Data Lake Storage         | Long term storage                 |                   |
| Key Vault                 | Keep secrets and credentails safe |                   |
| Log Analytics Workspace   | Query diagnostic logs             |                   |
| Synapse Workspace         | Main workspace for Analytics      | Intial deployment only cointains the Built-in Serverless SQL |
---
## Ownership

* Product Owner: [Arthur Steijn](https://teams.microsoft.com/l/chat/0/0?users=arthur.steijn@motion10.com)
* Solution Lead: [Jorgo de Muinck](https://teams.microsoft.com/l/chat/0/0?users=jorgo.demuinck@motion10.com)
* Technical Lead: [Jerrold Stolk](https://teams.microsoft.com/l/chat/0/0?users=jerrold.stolk@motion10.com)

<br/><br/>
<!-- GETTING STARTED -->
## Getting Started

--Steps to get a version deployed to our Azure Dev Subscription--

--Steps to get a version deployed for a customer--

## Prerequisites

List of things needed before deploying
* VS Code or Visual Studio
* CICD storage account and blob containers for ARM templates. In the Components repository this is done via an extra step in the yaml pipeline mdf-synapse-mvp-pipeline.yml.
The blob could also be created manually or via Azure blueprints [PitWall].
* Azure DevOps - service connection. The underlying service principal needs owner rights on the subscription to assign role assignments via RBAC

## Installation

1. The current set-up of mdf-synaspe [via mdf-synapse-mvp-pipeline.yml] is a deployment to two resource group for non-prd and prd - all in the same subscription*.

> \* At the client side, the deployment should be separated in at least two different subscriptions (f.e. nonp & prod) and three different resource groups (f.e. rg-dataplatform-dev + rg-dataplatform-tst + rg-dataplatform-prd).

2. Specify the correct parameters in mdf-synapse>parameters>./json[ARM] and in mdf-synapse-mvp-pipeline.yml
3. Run the pipeline mdf-synapse-mvp-pipeline.yml via Azure DevOps or GitHub Actions**

> \* Currently the deployment is bugged on the Microsoft Azure side. If the deployment fails  with a Not Found status on the synapse workspace, retry the deployment a second time.

4. Set up the acces control for the synapse workspace, see msdocs: [workspace acces control]
5. Check the Source Control settings in the non-prd workspace
5. You are ready to create changes to the synapse workspace 

<!-- USAGE EXAMPLES -->
## Usage

### CICD workflow

1. The non-prd environment is connected to a repository and changes are made on a 'topic' branch
2. A pull request merges the changes from the topic branch into the collaboration branch (main/master/develop)
3. After the pull request is completed,  publishing from the workspace GUI updates the publish branch
4. The publish branch is used as the artifact for the CICD deployment to the prd environment

<!-- ROADMAP -->
## Roadmap

t.b.d.

<!-- CONTRIBUTING -->
## Contributing

Any contributions you make are **greatly appreciated**.

Steps to contribute:

1. Create your Topic branch
2. a. Commit your [ARM] Changes **or**  b. Edit the [ADF] pipeline in the [GUI]
3. Push to the Topic branch
4. Open a Pull Request
5. Review by colleague
6. Merge Topic branch via squash commit to Master branch

<!-- CONTACT -->
## Contact

* [Arthur Steijn](https://teams.microsoft.com/l/chat/0/0?users=arthur.steijn@motion10.com) - arthur.steijn@motion10.com
* [Stefan Franke](https://teams.microsoft.com/l/chat/0/0?users=stefan.franke@motion10.com) - stefan.franke@motion10.com

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->
[git-issues]: https://github.com/Motion10-Solutions/Components/issues 
[workspace acces control]: https://docs.microsoft.com/en-us/azure/synapse-analytics/security/how-to-set-up-access-control