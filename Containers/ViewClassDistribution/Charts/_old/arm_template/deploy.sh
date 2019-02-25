set -o xtrace

rgName="lacesecurehd5"
rgLocation="Southeast Asia"
templateFile="./SecureHDInsight/azuredeploy.json"
parametersFile="./SecureHDInsight/azuredeploy.parameters.json"
vmName="lacezoo01"

az group create --name "$rgName" --location "$rgLocation"
az group deployment create --verbose \
    --resource-group "$rgName" \
    --template-file "$templateFile" \
    --parameters @"$parametersFile" \
    #--parameters vmName=$vmName \

# Show fqdns
az vm show -g "$rgName" -n $vmName -o json -d | grep fqdns


# az storage account network-rule list --resource-group "myresourcegroup" --account-name "mystorageaccount" --query virtualNetworkRules