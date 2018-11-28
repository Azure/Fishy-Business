$subscription = "3191ba83-be2b-4b29-8409-f06e2fbb65bd"
$rg_name = "InstanceSegmentation"
$rg_location = "australiaeast"
$storage_account_name = "instancesegmentation"
$aks_name = "InstanceSegmentation"
$acr_name = "InstanceSegmentation"
$sp_name = "http://InstanceSegmentation"

"Login"
az login

"Set Subscription"
az account set --subscription $subscription

"Create Resource Group"
az group create --name $rg_name --location $rg_location

"Create Storage Account"
az storage account create --resource-group $rg_name --name $storage_account_name --sku Standard_LRS

"Create File Shares"
$storage_connection_string = az storage account show-connection-string --resource-group $rg_name --name $storage_account_name -o tsv

az storage share create --connection-string $storage_connection_string --name 'frames'
az storage share create --connection-string $storage_connection_string --name 'labeledframes'
az storage share create --connection-string $storage_connection_string --name 'modeltraining'
az storage share create --connection-string $storage_connection_string --name 'modelweights'
az storage share create --connection-string $storage_connection_string --name 'video'

#$storage_acount_key = az storage account keys list --resource-group $rg_name --account-name $storage_account_name --query "[0].value" -o tsv

"Create Azure Kubernetes Service"
az aks create --resource-group $rg_name --name $aks_name --node-vm-size Standard_NC6 --node-count 1 --kubernetes-version 1.10.8 --generate-ssh-keys

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

"Create Service Principal for Azure Container Registry"
$acr_sp_password = az ad sp create-for-rbac --name $sp_name --scopes $acr_id --role contributor --query password --output tsv
$acr_sp_application_id = az ad sp show --id http://$sp_name --query appId --output tsv

"Authenticate Azure Kubernetes Service with Azure Container Registry"
$aks_sp_application_id = az aks show --resource-group $rg_name --name $aks_name --query "servicePrincipalProfile.clientId" --output tsv
az role assignment create --assignee $aks_sp_application_id --role Reader --scope $acr_id

"Install NVIDIA Device Plugin for Azure Kubernetes Service"
kubectl create -f https://raw.githubusercontent.com/NVIDIA/k8s-device-plugin/v1.10/nvidia-device-plugin.yml

"Create a Kubernetes Secret to access the File Shares"
kubectl create secret generic storage-account-secret --from-literal=storage_account_name=$storage_account_name --from-literal=storage_account_key=$storage_account_key

"Describe Node"
$aks_node_name = (kubectl get nodes --output json | ConvertFrom-Json).items[0].metadata.name
kubectl describe node $aks_node_name

#"Run Sample Job"
#kubectl apply -f samples-tf-mnist-demo.yaml
#kubectl get jobs samples-tf-mnist-demo --watch
#Ctrl-C
#kubectl get pods --selector app=samples-tf-mnist-demo
#$aks_pod_name = (kubectl get pods --selector app=samples-tf-mnist-demo --output json | ConvertFrom-Json).items[0].metadata.name
#kubectl logs $aks_pod_name
#kubectl delete jobs samples-tf-mnist-demo