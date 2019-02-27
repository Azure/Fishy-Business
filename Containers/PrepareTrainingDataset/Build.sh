# Build container and push to Development Azure Container Registry
subscription="3191ba83-be2b-4b29-8409-f06e2fbb65bd"
acr_name="InstanceSegmentationPipeline"
az login
az account set --subscription $subscription
cd ./Container
docker build -t prepare_training_dataset .
acr_login_server=$(az acr show --name $acr_name --query loginServer --output tsv)
tag="$acr_login_server/prepare_training_dataset"
docker tag prepare_training_dataset "$tag"
az acr login --name "$acr_name"
docker push "$tag"
