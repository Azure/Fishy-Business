# Build container and push to Development Azure Container Registry
subscription="3191ba83-be2b-4b29-8409-f06e2fbb65bd"
acr_name="InstanceSegmentationPipeline"
az login
az account set --subscription $subscription
acr_login_server=$(az acr show --name $acr_name --query loginServer --output tsv)
tag="$acr_login_server/create_metadata"
az acr login --name "$acr_name"
docker run -itd -p 8890:8890 $tag
