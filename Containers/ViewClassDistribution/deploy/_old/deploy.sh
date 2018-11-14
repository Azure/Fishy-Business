

# run image
docker run -it --env-file .docker.env --volume /mnt/z:/mnt/z ntfish-dataprep:latest bash

docker run -it -p 8888:8888 --volume /mnt/z:/mnt/z ntfish-dataprep:latest bash

--allow-root

##########################

rg_name=lacefish
acr_name=laceacr01
storage_account=ntfisheriesstore
storage_key=efmN1atTbzJquM6pNJp317V0pVWZKJMLNmpUhkU1/P+WrMdhzd5mee0kXc6wfztcR+MAQDbdsppbXdL9KATTag==
share_name=raw
mnt_path=/mnt/data/

# Create ACR
az acr create --resource-group $rg_name --name $acr_name --sku Basic --admin-enabled true

# Login
az acr login --name $acr_name

# Retrieve login servier
login_server=$(az acr show --name $acr_name --query loginServer --output tsv)

# build image
docker build -t ntfish-dataprep:v1 .

# Tag container image
docker tag ntfish-dataprep $login_server/ntfish-dataprep:v1

# Push image
docker push $login_server/ntfish-dataprep:v1

# 
az acr repository list --name $acr_name --output table

az acr repository show-tags --name $acr_name --repository ntfish-dataprep --output table

acr_password=$(az acr credential show --name $acr_name --query "passwords[0].value" --output tsv)

# # Create container instance
# az container create \
#     --resource-group $rg_name \
#     --name ntfishdataprep \
#     --image laceacr01/ntfish-dataprep \
#     --file dataprep.yaml \
#     --azure-file-volume-account-name $storage_account \
#     --azure-file-volume-account-key $storage_key \
#     --azure-file-volume-share-name $share_name \
#     --azure-file-volume-mount-path $mnt_path \
#     --registry-login-server $login_server \
#     --registry-username $acr_name \
#     --registry-password $acr_password

# Create container instance
az container create \
    --resource-group $rg_name \
    --name ntfishdataprep \
    --location southeastasia \
    --image $login_server/ntfish-dataprep:v1 \
    --azure-file-volume-account-name $storage_account \
    --azure-file-volume-account-key $storage_key \
    --azure-file-volume-share-name $share_name \
    --azure-file-volume-mount-path $mnt_path \
    --registry-login-server $login_server \
    --registry-username $acr_name \
    --registry-password $acr_password \
    --environment-variables VIDEO_FILE=BICPB3-20170519-5.MP4 \
    VIDEO_DIR=/mnt/data/video/Bathhurst UNPROCESSED_FRAMES_DIR=/mnt/data/dataprep/unprocessed ANALYZED_RESULTS_DIR=/mnt/data/dataprep/analyzed PROCESSED_FRAMES_DIR=/mnt/data/dataprep/processed


az container logs --resource-group $rg_name --name ntfishdataprep



## run