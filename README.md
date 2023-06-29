# IaC demo with Github Actions

## Prerequisites

* [Azure CLI](https://learn.microsoft.com/en-us/cli/azure/)
* [Azure account](https://azure.microsoft.com/en-us/free/) and [subscription](https://learn.microsoft.com/en-us/dynamics-nav/how-to--sign-up-for-a-microsoft-azure-subscription)
* A [service principal](https://learn.microsoft.com/en-us/cli/azure/create-an-azure-service-principal-azure-cli) in your Azure subscription

__Heads up!__ Make sure  __Save__ the __password__ generated for the service principal. It is only visible on the output after creation.

## Setup

Create the following environment variables:
```
ARM_CLIENT_ID = "<SPN_APPID_VALUE>"
ARM_CLIENT_SECRET = "<SPN_CLIENT_SECRET_VALUE>"
ARM_SUBSCRIPTION_ID = "<YOUR_SUBSCRIPTION_ID>"
ARM_TENANT_ID = "<YOUR_TENANT_ID>"

AZURE_REGION = "<ANY_VALID_AZURE_REGION>"
RG_NAME = "<ANY_VALID_RG_NAME>"
DOCKER_USR = "<YOUR_DOCKER_USER>"
DOCKER_IMAGE = "<DOCKE_IMAGE_TO_DEPLOY>"
```
You can find your __<SPN_APPID_VALUE>__ in the Azure portal, under _Azure Active Directory_ > _App registrations_ > _Application (client) ID_.

The __<SPN_CLIENT_SECRET_VALUE>__ is the __password__ generated for the service principle. It is only visible on the output after creation. If you have lost it, you will need to [reset it](https://learn.microsoft.com/en-us/cli/azure/ad/sp/credential?view=azure-cli-latest#az-ad-sp-credential-reset).

The __<DOCKE_IMAGE_TO_DEPLOY>__ must be public and the bicep template will deploy the _latest_ tag.

## Infrastructure

Open a terminal and navigate to the ``infrastructure`` folder of this project. For a dry-run (see what will be done, but not actually do it):
* ``az deployment sub what-if -l northeurope --template-file main.bicep --parameters rgName=${env:RG_NAME} location=${env:AZURE_REGION} dockerHubUser=${env:DOCKER_USR} dockerImage=${env:DOCKER_IMAGE}``

If you are happy with the result of the above command, execute it by changing ``what-if`` with ``create``:
* ``az deployment sub create -l northeurope --template-file main.bicep --parameters rgName=${env:RG_NAME} location=${env:AZURE_REGION} dockerHubUser=${env:DOCKER_USR} dockerImage=${env:DOCKER_IMAGE}``

This will create an App Service Plan, containing one App Service, with continuous deployment active and the docker image you specified deployed.