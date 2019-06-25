#!/bin/bash
Suscr="InfraLab"
RGNameGlobal="vdc1-energisme-rg-global"
Location="WestEurope"


RGName0="vdc1-energisme-rg-dmz"
RGName1="vdc1-energisme-rg-dev"
RGName2="vdc1-energisme-rg-rct"
RGName3="vdc1-energisme-rg-int"
RGName4="vdc1-energisme-rg-pprod"
RGName5="vdc1-energisme-rg-prod"
RGName6="vdc1-energisme-rg-devops"

Vnet0="energisme-vnet-dmz"      ; Snet0a="energisme-snet-frontend-dmz"           
Vnet1="energisme-vnet-dev" 	; Snet1a="energisme-snet-frontend-dev"		 ; Snet1b="energisme-snet-backend-dev"        ; Snet1c="energisme-snet-data-dev"
Vnet2="energisme-vnet-rct"      ; Snet2a="energisme-snet-frontend-rct" 		 ; Snet2b="energisme-snet-backend-rct"        ; Snet2c="energisme-snet-data-rct"
Vnet3="energisme-vnet-int"      ; Snet3a="energisme-snet-frontend-int"           ; Snet3b="energisme-snet-backend-int"        ; Snet3c="energisme-snet-data-int"
Vnet4="energisme-vnet-pprod"    ; Snet4a="energisme-snet-frontend-pprod"         ; Snet4b="energisme-snet-backend-pprod"      ; Snet4c="energisme-snet-data-pprod"
Vnet5="energisme-vnet-prod"     ; Snet5a="energisme-snet-frontend-prod"          ; Snet5b="energisme-snet-backend-prod"       ; Snet5c="energisme-snet-data-prod"
Vnet6="energisme-vnet-devops"   ; Snet6a="energisme-snet-devops"                 ; Snet6b="energisme-snet-devops-ro"          

Address_space_Vnet0="192.150.0.0/16"        ; Address_space_Snet0a="192.150.128.0/26"
Address_space_Vnet1="192.100.0.0/16"        ; Address_space_Snet1a="192.100.128.0/26"    ; Address_space_Snet1b="192.100.64.0/26"       ; Address_space_Snet1c="192.100.20.0/26" 
Address_space_Vnet2="192.200.0.0/16" 	    ; Address_space_Snet2a="192.200.128.0/26"    ; Address_space_Snet2b="192.200.64.0/26"       ; Address_space_Snet2c="192.200.20.0/26"
Address_space_Vnet3="192.232.0.0/16"        ; Address_space_Snet3a="192.232.128.0/26"    ; Address_space_Snet3b="192.232.64.0/26"       ; Address_space_Snet3c="192.232.20.0/26"
Address_space_Vnet4="192.168.0.0/16"        ; Address_space_Snet4a="192.168.128.0/26"    ; Address_space_Snet4b="192.168.64.0/26"       ; Address_space_Snet4c="192.168.20.0/26"
Address_space_Vnet5="192.50.0.0/16"         ; Address_space_Snet5a="192.50.128.0/26"     ; Address_space_Snet5b="192.50.64.0/26"        ; Address_space_Snet5c="192.50.20.0/26"
Address_space_Vnet6="192.10.0.0/16"         ; Address_space_Snet6a="192.10.128.0/26"     ; Address_space_Snet6b="192.10.64.0/26"

ContainerName="tfbackend"
Bckvault="bck-energisme-vdc1"
role="owner"   # or  Contributor

suscb_id="1c172835-4f36-47f0-a300-f04192e27d65"
kv_infra_name="kv-infra-vdc1"
apps_registration_name="VDC1-ENERGISME-API-IaaC"
sa_infra_name="vdc1saglobal"
rg_infra_name="vdc1-energisme-rg-global"

apps_registration_id=$(az ad app show --id http://$apps_registration_name | jq '.appId' | tr -d '"')
# Create RBAC
az ad sp create-for-rbac --name $apps_registration_name  --password Azerty123456 | jq '.appId' | tr -d '"'
apps_registration_pwd=$(az ad sp create-for-rbac --name $apps_registration_name | jq '.password' | tr -d '"')

echo $apps_registration_pwd


# Create a resource group $RGName
az group create \
  --name $RGNameGlobal  \
  --location $Location

# Create a resource group $RGName0
az group create \
  --name $RGName0  \
  --location $Location

# Create a resource group $RGName1
az group create \
  --name $RGName1  \
  --location $Location

# Create a resource group $RGName2
az group create \
  --name $RGName2 \
  --location $Location

# Create a resource group $RGName3
az group create \
  --name $RGName3  \
  --location $Location

# Create a resource group $RGName4
az group create \
  --name $RGName4  \
  --location $Location

# Create a resource group $RGName5
az group create \
  --name $RGName5  \
  --location $Location

# Create a resource group $RGName6
az group create \
  --name $RGName6  \
  --location $Location

# Create virtual network 0.
az network vnet create \
  --name $Vnet0 \
  --resource-group $RGNameGlobal \
  --location $Location \
  --address-prefix $Address_space_Vnet0 \
  --subnet-name $Snet0a \
  --subnet-prefix $Address_space_Snet0a \


# Create virtual network 1.
az network vnet create \
  --name $Vnet1 \
  --resource-group $RGNameGlobal \
  --location $Location \
  --address-prefix $Address_space_Vnet1 \
  --subnet-name $Snet1a \
  --subnet-prefix $Address_space_Snet1a \

az network vnet subnet create -n $Snet1b --vnet-name $Vnet1 -g $RGNameGlobal --address-prefixes $Address_space_Snet1b
az network vnet subnet create -n $Snet1c --vnet-name $Vnet1 -g $RGNameGlobal --address-prefixes $Address_space_Snet1c

# Create virtual network 2.
az network vnet create \
  --name $Vnet2 \
  --resource-group $RGNameGlobal \
  --location $Location \
  --address-prefix $Address_space_Vnet2 \
  --subnet-name $Snet2a \
  --subnet-prefix $Address_space_Snet2a \

az network vnet subnet create -n $Snet2b --vnet-name $Vnet2 -g $RGNameGlobal --address-prefixes $Address_space_Snet2b
az network vnet subnet create -n $Snet2c --vnet-name $Vnet2 -g $RGNameGlobal --address-prefixes $Address_space_Snet2c

# Create virtual network 3.
az network vnet create \
  --name $Vnet3 \
  --resource-group $RGNameGlobal \
  --location $Location \
  --address-prefix $Address_space_Vnet3 \
  --subnet-name $Snet3a \
  --subnet-prefix $Address_space_Snet3a \

az network vnet subnet create -n $Snet3b --vnet-name $Vnet3 -g $RGNameGlobal --address-prefixes $Address_space_Snet3b
az network vnet subnet create -n $Snet3c --vnet-name $Vnet3 -g $RGNameGlobal --address-prefixes $Address_space_Snet3c

# Create virtual network 4.
az network vnet create \
  --name $Vnet4 \
  --resource-group $RGNameGlobal \
  --location $Location \
  --address-prefix $Address_space_Vnet4\
  --subnet-name $Snet4a \
  --subnet-prefix $Address_space_Snet4a \

az network vnet subnet create -n $Snet4b --vnet-name $Vnet4 -g $RGNameGlobal --address-prefixes $Address_space_Snet4b
az network vnet subnet create -n $Snet4c --vnet-name $Vnet4 -g $RGNameGlobal --address-prefixes $Address_space_Snet4c

# Create virtual network 5.
az network vnet create \
  --name $Vnet5 \
  --resource-group $RGNameGlobal \
  --location $Location \
  --address-prefix $Address_space_Vnet5 \
  --subnet-name $Snet5a \
  --subnet-prefix $Address_space_Snet5a \

az network vnet subnet create -n $Snet5b --vnet-name $Vnet5 -g $RGNameGlobal --address-prefixes $Address_space_Snet5b
az network vnet subnet create -n $Snet5c --vnet-name $Vnet5 -g $RGNameGlobal --address-prefixes $Address_space_Snet5c

# Create virtual network 6.
az network vnet create \
  --name $Vnet6 \
  --resource-group $RGNameGlobal \
  --location $Location \
  --address-prefix $Address_space_Vnet6 \
  --subnet-name $Snet6a \
  --subnet-prefix $Address_space_Snet6a \

az network vnet subnet create -n $Snet6b --vnet-name $Vnet6 -g $RGNameGlobal --address-prefixes $Address_space_Snet6b
# az network vnet subnet create -n $Snet6c --vnet-name $Vnet6 -g $RGNameGlobal --address-prefixes $Address_space_Snet6c


# Create RBAC
az ad sp create-for-rbac --name $apps_registration_name  --password Azerty123456 | jq '.appId' | tr -d '"'

# Create Key Vault
az keyvault create --name $kv_infra_name --resource-group $RGNameGlobal --location $Location | jq '.id' | tr -d '"'
az keyvault secret set --name $apps_registration_name --vault-name $kv_infra_name --value $apps_registration_pwd

# Create Storage Account
az storage account create --name $sa_infra_name --resource-group $rg_infra_name --sku Standard_LRS | jq '.id' | tr -d '"'

# Assignment roles
az role assignment create --assignee $apps_registration_id --role $role --scope /subscriptions/$suscb_id

# Create Storage Account 
az storage container create --name $ContainerName \
		            --account-name $sa_infra_name \
                            --public-access container

# Create Backup Vault Recovery
az backup vault create --location $Location --name $Bckvault  --resource-group $RGNameGlobal


# Assignment roles
az role assignment create --assignee $apps_registration_id --role $role --scope /subscriptions/$suscb_id


# Get the id for VNet0.
Vnet0Id=$(az network vnet show \
  --resource-group $RGNameGlobal \
  --name $Vnet0 \
  --query id \
  --out tsv)

# Get the id for VNet1.
Vnet1Id=$(az network vnet show \
  --resource-group $RGNameGlobal \
  --name $Vnet1 \
  --query id \
  --out tsv)

# Get the id for VNet2.
Vnet2Id=$(az network vnet show \
  --resource-group $RGNameGlobal \
  --name $Vnet2 \
  --query id \
  --out tsv)

# Get the id for VNet3.
Vnet3Id=$(az network vnet show \
  --resource-group $RGNameGlobal \
  --name $Vnet3 \
  --query id \
  --out tsv)

# Get the id for VNet4.
Vnet4Id=$(az network vnet show \
  --resource-group $RGNameGlobal \
  --name $Vnet4 \
  --query id \
  --out tsv)

# Get the id for VNet5.
Vnet5Id=$(az network vnet show \
  --resource-group $RGNameGlobal \
  --name $Vnet5 \
  --query id \
  --out tsv)

# Get the id for VNet6.
Vnet6Id=$(az network vnet show \
  --resource-group $RGNameGlobal \
  --name $Vnet6 \
  --query id \
  --out tsv)

# Peer VNet0 to VNet6.
az network vnet peering create \
  --name $Vnet0.To.$Vnet6 \
  --resource-group $RGNameGlobal \
  --vnet-name $Vnet0 \
  --remote-vnet-id $Vnet6Id \
  --allow-vnet-access

# Peer VNet6 to VNet0.
az network vnet peering create \
  --name $Vnet6.To.$Vnet0 \
  --resource-group $RGNameGlobal \
  --vnet-name $Vnet6 \
  --remote-vnet-id $Vnet0Id \
  --allow-vnet-access

# Peer VNet6 to VNet1.
az network vnet peering create \
  --name $Vnet6.To.$Vnet1 \
  --resource-group $RGNameGlobal \
  --vnet-name $Vnet6 \
  --remote-vnet-id $Vnet1Id \
  --allow-vnet-access

# Peer VNet6 to VNet2.
az network vnet peering create \
  --name $Vnet6.To.$Vnet2 \
  --resource-group $RGNameGlobal \
  --vnet-name $Vnet6 \
  --remote-vnet-id $Vnet2Id \
  --allow-vnet-access

# Peer VNet6 to VNet3.
az network vnet peering create \
  --name $Vnet6.To.$Vnet3 \
  --resource-group $RGNameGlobal \
  --vnet-name $Vnet6 \
  --remote-vnet-id $Vnet3Id \
  --allow-vnet-access

# Peer VNet6 to VNet4.
az network vnet peering create \
  --name $Vnet6.To.$Vnet4 \
  --resource-group $RGNameGlobal \
  --vnet-name $Vnet6 \
  --remote-vnet-id $Vnet4Id \
  --allow-vnet-access

# Peer VNet6 to VNet5.
az network vnet peering create \
  --name $Vnet6.To.$Vnet5 \
  --resource-group $RGNameGlobal \
  --vnet-name $Vnet6 \
  --remote-vnet-id $Vnet5Id \
  --allow-vnet-access

