$subscription = "3191ba83-be2b-4b29-8409-f06e2fbb65bd"
$storage_account_name = "mladsf2018"
$rg_name = "MLADSF2018"
$rg_location = "westus2"
$aks_name = "MLADSF2018"
$acr_name = "MLADSF2018"
$sp_name = "MLADSF2018"

"Set Subscription"
az account set --subscription $subscription

"Create Storage Account"
az storage account create -name $storage_account_name --resource-group $rg_name --sku Standard_LRS

"Create Resource Group"
az group create --name $rg_name --location $rg_location

"Create Azure Kubernetes Service"
az aks create --resource-group $rg_name --name $aks_name --node-vm-size Standard_NC6 --node-count 1 --kubernetes-version 1.10.8

"Get Azure Kubernetes Service Credentials"
az aks get-credentials --resource-group $rg_name --name $aks_name

"Authenticate Helm with Azure Kubernetes Service"
kubectl apply -f helm-rbac.yaml

"Deploy Tiller to Azure Kubernetes Service"
helm init --service-account tiller

"Create Azure Container Registry"
az acr create --resource-group $rg_name --name $acr_name --sku Basic
az acr login --name $acr_name

$acr_id = az acr show --name $acr_name --query id --output tsv
$acr_login_server = az acr show --name $acr_name --query loginServer --output tsv

"Create Service Principal for Azure Container Registry"
$acr_sp_password = az ad sp create-for-rbac --name $sp_name --scopes $acr_id --role contributor --query password --output tsv
$acr_sp_application_id = az ad sp show --id http://$sp_name --query appId --output tsv

"Authenticate Azure Kubernetes Service with Azure Container Registry"
$aks_sp_application_id = az aks show --resource-group $rg_name --name $aks_name --query "servicePrincipalProfile.clientId" --output tsv
az role assignment create --assignee $aks_sp_application_id --role Reader --scope $acr_id

"Install NVIDIA Device Plugin for Azure Kubernetes Service"
kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v1.10/nvidia-device-plugin.yml