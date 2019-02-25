# Build container and push to Development Azure Container Registry
$subscription = "3191ba83-be2b-4b29-8409-f06e2fbb65bd"
$acr_name = "InstanceSegmentationPipeline"

"Login"
az login

"Set Subscription"
az account set --subscription $subscription

"Build Container"
cd .\Container

docker build -t view_class_distribution .

$acr_login_server = az acr show --name $acr_name --query loginServer --output tsv

$tag = "{0}/view_class_distribution" -f $acr_login_server

docker tag view_class_distribution $tag

"Push Container to Azure Container Registry"

az acr login --name $acr_name

docker push $tag