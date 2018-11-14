
#set -o errexit
#set -o pipefail
#set -o nounset
set -o xtrace

# REQUIREMENTS:
# az cli, docker, kubectl
# You need to be login to the appropriate azure sub. Use az login.

##############################################
### SET VARIABLES ###

rg_name=ntfish-dataprep
rg_location=australiaeast
acr_name=ntfishdataprepacr
aks_name=ntfishataprepaks
stor_name=ntfisheriesstoreeast # This should already exist!
stor_key=1+s7Vu4JAGFzMDNZvKqmeB2c+JVf3ckq43+yh3yImIKnpo2p1oDlD8rMzkDuga+Xc9HVPeUERxXwDKXiIqCwcQ==

# Create resource group
az group create --name "$rg_name" --location "$rg_location"

##############################################
### Create ACR and build/push Docker image ###

# Create ACR
az acr create \
    --resource-group $rg_name \
    --name $acr_name \
    --sku Basic \
    --admin-enabled true

# Login
az acr login --name $acr_name

# Retrieve login servier
login_server=$(az acr show --name $acr_name --query loginServer --output tsv)

# build image
docker build -t ntfish-dataprep:v1 .

# Tag container image
docker tag ntfish-dataprep:v1 $login_server/ntfish-dataprep:v1

# Push image
docker push $login_server/ntfish-dataprep:v1

##############################################
### AKS ###

# Create aks cluster
az aks create \
    --resource-group "$rg_name" \
    --name "$aks_name" \
    --node-count 2 \
    --generate-ssh-keys

# Login to ACR
az aks get-credentials --resource-group "$rg_name" --name "$aks_name"

# Generate AKS secret 
kubectl create secret generic storage-secret \
    --from-literal=azurestorageaccountname="$stor_name" \
    --from-literal=azurestorageaccountkey="$stor_key"

##############################################
### Authentication AKS to ACR ###

# Retrive SP client Id of AKS
acr_clientid=$(az aks show --resource-group "$rg_name" --name "$aks_name" --query "servicePrincipalProfile.clientId" --output tsv)
# Retrieve ACR resource Id
acr_rid=$(az acr show --name "$acr_name" --resource-group "$rg_name" --query "id" --output tsv)
# Assign SP to ACR
az role assignment create \
    --assignee "$acr_clientid" \
    --role Reader --scope "$acr_rid"
