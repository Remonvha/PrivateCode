# Databricks notebook source
from azureml.core.webservice import AciWebservice, Webservice
import azureml
import mlflow.sklearn
from azureml.core.authentication import ServicePrincipalAuthentication
from azureml.mlflow import get_portal_url
from azureml.core import Workspace
import azureml.core
import azureml.mlflow
import mlflow.azureml
import mlflow
# get name of model

# COMMAND ----------

dbutils.widgets.text(
    name="model_name", defaultValue="ml-gov-demo-wine-model", label="Model Name")
dbutils.widgets.text(name="stage", defaultValue="staging", label="Stage")
dbutils.widgets.text(name="phase", defaultValue="qa", label="Phase")

# COMMAND ----------

model_name = dbutils.widgets.get("model_name")
stage = dbutils.widgets.get("stage")
phase = dbutils.widgets.get("phase")

# COMMAND ----------

# Config for AzureML Workspace
# for secure keeping, store credentials in Azure Key Vault and link using Azure Databricks secrets with dbutils
#subscription_id = dbutils.secrets.get(scope = "common-sp", key ="az-sub-id")
subscription_id = "<subscription id >
resource_group = "ok-azureml-test"
workspace_name = "ok-azureml-test"
tenant_id = "<tenant id>"  # Tenant ID
sp_id = dbutils.secrets.get(
    scope="common-sp", key="common-sa-sp-client-id")  # Service Principal ID
sp_secret = dbutils.secrets.get(
    scope="common-sp", key="common-sa-sp-client-secret")  # Service Principal Secret

# COMMAND ----------


print("AzureML SDK version:", azureml.core.VERSION)
print("MLflow version:", mlflow.version.VERSION)
AzureML SDK version: 1.5.0
MLflow version: 1.7.0

# COMMAND ----------


def service_principal_auth():
    return ServicePrincipalAuthentication(
        tenant_id=tenant_id,
        service_principal_id=sp_id,
        service_principal_password=sp_secret)

# COMMAND ----------


# get the latest version of the model

client = mlflow.tracking.MlflowClient()
latest_model = client.get_latest_versions(name=model_name, stages=[stage])
# print(latest_model[0])

# COMMAND ----------

model_uri = "runs:/{}/model".format(latest_model[0].run_id)
latest_sk_model = mlflow.sklearn.load_model(model_uri)

# COMMAND ----------

# Before models can be deployed to Azure ML, an Azure ML Workspace must be created or obtained. The azureml.core.Workspace.create() function will load a workspace of a specified name or create one if it does not already exist. For more information about creating an Azure ML Workspace, see the Azure ML Workspace management documentation.

# If you don't have a service principal, use 'interactive' for interactive login
workspace = azureml_workspace(auth_type='service_princpal')

# COMMAND ----------

# We will use the mlflow.azuereml.build_image function to build an Azure Container Image for the trained MLflow model. This function also registers the MLflow model with a specified Azure ML workspace. The resulting image can be deployed to Azure Container Instances (ACI) or Azure Kubernetes Service (AKS) for real-time servin

print(phase)
qa

# COMMAND ----------


model_image, azure_model = mlflow.azureml.build_image(model_uri=model_uri, workspace=workspace, model_name=model_name+"-"+stage, image_name=model_name +
                                                      "-"+phase+"-image", description=model_name, tags={"alpha": str(latest_sk_model.alpha), "l1_ratio": str(latest_sk_model.l1_ratio), }, synchronous=True)

# COMMAND ----------

model_image.wait_for_creation(show_output=True)

# COMMAND ----------

# Deploying the model to "dev" using Azure Container Instances (ACI) The ACI platform is the recommended environment for staging and developmental model deployments. Create an ACI webservice deployment using the model's Container Image Using the Azure ML SDK, we will deploy the Container Image that we built for the trained MLflow model to ACI.
# make sure this name is unique and doesnt already exist, else need to replace
dev_webservice_name = model_name+"-"+phase
dev_webservice_deployment_config = AciWebservice.deploy_configuration()
dev_webservice = Webservice.deploy_from_image(name=dev_webservice_name, image=model_image,
                                              deployment_config=dev_webservice_deployment_config, workspace=workspace, overwrite=True)

# COMMAND ----------

dev_webservice.wait_for_deployment()

# COMMAND ----------

dev_scoring_uri = dev_webservice.scoring_uri

# COMMAND ----------

print(dev_scoring_uri)

# COMMAND ----------
