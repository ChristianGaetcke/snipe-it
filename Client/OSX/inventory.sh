#!/usr/bin/env bash

#####################################################
# Scripted by: Christian Gätcke 					
# Created on: 02/07/2020  							
#####################################################

##########################################################
# Global variables 
# $apiKey = '' your SnipeIt API Key	 
# example:
# $apiKey = '.......iIsImp0aSI6IjJmMDkyNDg5MzZk....'     
# $baseUrl = '' the Base-Url of your SnipeIT installation
# example:
# $baseUrl = 'https://snipeit.example.com'
#########################################################
apiKey=""
baseUrl=""

########################################
# enable the GUI?                       
# yes:  enableGUI=1                     
# only inventorize asset:  enableGUI= 0 
# This will not create a user           
########################################
enableGUI="1"

####################################
# automatically get asset tag?      
# yes: getTag=0                    
# no : getTag=1                    
####################################
getTag="1"

####################################################################################
# Snipe specific fields:								  							
# To store values like Ram, CPU, Mac etc, a fieldset with 							
# the corresponding fields needs to be created in snipe.  							
# See: https://snipe-it.readme.io/docs/custom-fields#common-custom-fields-regexes	
# Fieldset-ID:																		
# example: fsField = "2"															
# CPU-Field:																		
# example: cpuField = "_snipeit_cpu_4"												
# RAM-Field:																		
# example: ramField = "_snipeit_ram_2"												
# Macaddress-Field:																	
# example: macField = "_snipeit_mac_address_1"										
# Disk-Field:																		
# example: diskField = "_snipeit_disksize_3"										
# Operatingsystem-Field																
# example: osField = "_snipeit_operating_system_6"									
# The examples won't work out of the box and need to be generated first				
# 																					
# $statusID is the status checked out assets will be transferred to					
# example: statusID = "2"															
####################################################################################
fsField=""
cpuField=""
ramField=""
macField=""
diskField=""
osField=""
statusID=""

####################
#generate Random PW
#of length 12	   
####################
ranPass=$(openssl rand -hex 12)

####################
#logic for pashua
#	   GUI
####################

if [ "$enableGUI" = "1" ]
then
MYDIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
 ###########################################################################
 #Include pashua.sh to be able to use the 2 functions defined in that file
 ###########################################################################
source "$MYDIR/pashua.sh"
 #################################################################
 #Define what the dialog should be like
 #Take a look at Pashua's Readme file for more info on the syntax
 #################################################################
if [ "$getTag" = "1" ]
then
conf="
#Set window title
*.title = Inventorization
*.x = 350
*.y = 200
#Add a text field
tf.type = textfield
tf.label = Emailaddress
tf.default = 
tf.width = 310
tf2.type = textfield
tf2.label = Asset Tag
tf2.default = 
tf2.width = 310
#tf.tooltip = This is an element of type “textfield”
#Add a cancel button with default label
cb.type = cancelbutton
cb.tooltip = This is an element of type “cancelbutton”
db.type = defaultbutton
db.tooltip = Inventorize my device
"
else
conf="
#Set window title
*.title = Inventorization
*.x = 350
*.y = 200
#Add a text field
tf.type = textfield
tf.label = Emailaddress
tf.default = 
tf.width = 310
#tf.tooltip = This is an element of type “textfield”
#Add a cancel button with default label
cb.type = cancelbutton
cb.tooltip = This is an element of type “cancelbutton”
db.type = defaultbutton
db.tooltip = Inventorize my device
"
fi
if [ -d '/Volumes/Pashua/Pashua.app' ]
then
	###############################################################
	# Looks like the Pashua disk image is mounted. Run from there.
	###############################################################
	customLocation='/Volumes/Pashua'
else
	#################################################
	# Search for Pashua in the standard locations
	#################################################
	customLocation=''
fi
pashua_run "$conf" "$customLocation"
fi
if [ "$cb" = "1" ]
then
exit
else
#########################################
# 				system Info	   		    
#########################################
assetName=$(hostname)
sysModel=$(system_profiler SPHardwareDataType | grep 'Model Name' | cut -d ":" -f2)
sysManufacturer="Apple"
serialNumber=$(system_profiler SPHardwareDataType | grep 'Serial Number' | cut -d ":" -f2 | xargs)
ramSize=$(system_profiler SPHardwareDataType | grep 'Memory' | cut -d ":" -f2)
diskSize=$(df -H | awk '/\/dev\/disk1s1/ {printf("%s\n", $2)}' | tr -d "G")
diskSize+=" GB"
macAddress=$(networksetup -listallhardwareports | grep Wi-Fi -A 3 | awk '/Ethernet Address:/{print $3}'|xargs)
sysFull=$(sysctl hw.model | cut -d ":" -f2 | tr -d "\t" | xargs)
osName=$(sw_vers | grep 'ProductName'  | cut -d ":" -f2 | tr -d '\t') 
osVer=$(sw_vers | grep 'ProductVersion'  | cut -d ":" -f2 | tr -d '\t') 
os="$osName - $osVer"
emailAddress=$tf
tagString=$tf2

#########################################
# Switch case for different categpories 
# Please extend as necessary
#########################################

case "$sysFull" in
	Macmini[1..9]* ) category="Desktop" ;;
	MacBook[1..9]* ) category="Laptop" ;;
	MacBookPro[1..9]* ) category="Laptop" ;;
	MacBookAir[1..9]* ) category="Laptop" ;;
esac

cpu=$((system_profiler SPHardwareDataType | grep 'Processor Name' | cut -d ":" -f2) ; (system_profiler SPHardwareDataType | grep 'Processor Speed' | cut -d ":" -f2) | cat)
cpu=$(echo "$cpu" | tr -d "\n")

#########################################
# 		 get username and split    	    
#########################################

username=$(echo "$emailAddress" | cut -d "@" -f1)
echo $username | tr -cd '.' | wc -c | tr -d "\t" 

dc=$(echo "${username}" | awk -F"." '{print NF-1}')

if [ "$dc" = "1" ] 
then 
	firstName=$(echo "$username" | cut -d "." -f1) 
	lastName=$(echo "$username" | cut -d "." -f2)
else
	firstName=$(echo "$username" | cut -d "." -f1)
fi

########################################
# 		curl for manufacturer  		    
#		create if non-existant			
#		then get manufacturer-ID		
########################################
manu=$(curl --request GET \
--url "$baseUrl/api/v1/manufacturers?search=$sysManufacturer" \
--header 'accept: application/json' \
--header "authorization: Bearer $apiKey" \
--header 'content-type: application/json')

if [ "$manu" = '{"total":0,"rows":[]}' ]
then
	curl --request POST \
--url "$baseUrl/api/v1/manufacturers" \
--header 'accept: application/json' \
--header "authorization: Bearer $apiKey" \
--header 'content-type: application/json' \
--data '{"name":"'$sysManufacturer'"}'
else
	echo "Manufacturer exists"
fi

manuId=$(curl --request GET \
--url "$baseUrl/api/v1/manufacturers?search=$sysManufacturer" \
--header 'accept: application/json' \
--header "authorization: Bearer $apiKey" \
--header 'content-type: application/json')
manuId=$(echo "$manuId" | sed -E 's/.*"id":"?([^,"]*)"?.*/\1/' | xargs)
echo $manuId
echo $manu

########################################
# 		curl for category  		    	
#		create if non-existant			
#		then get category-ID			
########################################

cat=$(curl --request GET \
--url "$baseUrl/api/v1/categories?search=$category" \
--header 'accept: application/json' \
--header "authorization: Bearer $apiKey" \
--header 'content-type: application/json')

if [ "$cat" = '{"total":0,"rows":[]}' ]
then
	curl --request POST \
--url "$baseUrl/api/v1/categories" \
--header 'accept: application/json' \
--header "authorization: Bearer $apiKey" \
--header 'content-type: application/json' \
--data '{"name": "'"$category"'", "manufacturer_id": "'"$manuId"'"}'
else
	echo "Category exists"
fi

catId=$(curl --request GET \
--url "$baseUrl/api/v1/categories?search=$category" \
--header 'accept: application/json' \
--header "authorization: Bearer $apiKey" \
--header 'content-type: application/json')
catId=$(echo "$catId" | sed -E 's/.*"id":"?([^,"]*)"?.*/\1/' | xargs)
echo $category
echo $cat
echo $catId

########################################
# 		curl for model  		    	
#		create if non-existant			
#		then get model-ID				
########################################
model=$(curl --request GET \
--url "$baseUrl/api/v1/models?search=$sysFull" \
--header 'accept: application/json' \
--header "authorization: Bearer $apiKey" \
--header 'content-type: application/json')

if [ "$model" = '{"total":0,"rows":[]}' ]
then
	curl --request POST \
--url "$baseUrl/api/v1/models" \
--header 'accept: application/json' \
--header "authorization: Bearer $apiKey" \
--header 'content-type: application/json' \
--data '{"name": "'"$sysFull"'", "manufacturer_id": "'"$manuId"'", "category_id":"3", "fieldset_id":"2"}'
else
	echo "Model exists"
fi

modelId=$(curl --request GET \
--url "$baseUrl/api/v1/models?search=$sysFull" \
--header 'accept: application/json' \
--header "authorization: Bearer $apiKey" \
--header 'content-type: application/json')
modelId=$(echo "$modelId" | sed -E 's/."id":"?([^,"]*)"?.*/\1/' |cut -d "[" -f2 | xargs)
echo $model
echo $modelId

########################################
# 		curl for asset  		    	
#		create if non-existant			
#		then get asset-ID				
########################################

asset=$(curl --request GET \
--url "$baseUrl/api/v1/hardware?search=$serialNumber" \
--header 'accept: application/json' \
--header "authorization: Bearer $apiKey" \
--header 'content-type: application/json')



if [ "$asset" = '{"total":0,"rows":[]}' ]
then
if [ "$getTag" = "0" ]
then
	curl --request POST \
--url "$baseUrl/api/v1/hardware" \
--header 'accept: application/json' \
--header "authorization: Bearer $apiKey" \
--header 'content-type: application/json' \
--data '{"model_id":'"$modelId"',"status_id": 2,"name": "'"$assetName"'", "serial": "'"$serialNumber"'", "'"$diskField"'": "'"$diskSize"'", "'"$macField"'": "'"$macAddress"'","'"$ramField"'": "'"$ramSize"'", "'"$osField"'": "'"$os"'", "'"$cpuField"'": "'"$cpu"'" }'
else
	curl --request POST \
--url "$baseUrl/api/v1/hardware" \
--header 'accept: application/json' \
--header "authorization: Bearer $apiKey" \
--header 'content-type: application/json' \
--data '{"model_id":'"$modelId"',"asset_tag":"'"$tagString"'","status_id": 2,"name": "'"$assetName"'", "serial": "'"$serialNumber"'", "'"$diskField"'": "'"$diskSize"'", "'"$macField"'": "'"$macAddress"'","'"$ramField"'": "'"$ramSize"'", "'"$osField"'": "'"$os"'", "'"$cpuField"'": "'"$cpu"'" }'
fi
else
	echo "Asset exists"
fi

assetId=$(curl --request GET \
--url "$baseUrl/api/v1/hardware?search=$serialNumber" \
--header 'accept: application/json' \
--header "authorization: Bearer $apiKey" \
--header 'content-type: application/json')
assetId=$(echo "$assetId" | sed -E 's/."id":"?([^,"]*)"?.*/\1/' |cut -d "[" -f2 | xargs)
echo $asset
echo $assetId


if [ "$enableGUI" = "1" ]
then
########################################
# 		curl for user	  		    	
#		create if non-existant			
#		then get user-ID				
########################################
user=$(curl --request GET \
--url "$baseUrl/api/v1/users?search=$emailAddress" \
--header 'accept: application/json' \
--header "authorization: Bearer $apiKey" \
--header 'content-type: application/json')

if [ "$user" = '{"total":0,"rows":[]}' ]
then
	curl --request POST \
--url "$baseUrl/api/v1/users" \
--header 'accept: application/json' \
--header "authorization: Bearer $apiKey" \
--header 'content-type: application/json' \
--data '{"first_name": "'"$firstName"'","username": "'"$username"'", "password": "'"$ranPass"'", "password_confirmation": "'"$ranPass"'", "email": "'"$emailAddress"'", "activated":false}'
else
	echo "User exists"
fi

userId=$(curl --request GET \
--url "$baseUrl/api/v1/users?search=$emailAddress" \
--header 'accept: application/json' \
--header "authorization: Bearer $apiKey" \
--header 'content-type: application/json')
userId=$(echo "$userId" | sed -E 's/."id":"?([^,"]*)"?.*/\1/' |cut -d "[" -f2 | xargs)
echo $user
echo $userId

#########################################
# 	checkout asset to user			
#########################################
curl --request POST \
--url "$baseUrl/api/v1/hardware/$assetId/checkout" \
--header 'accept: application/json' \
--header "authorization: Bearer $apiKey" \
--header 'content-type: application/json' \
--data '{"checkout_to_type": "user", "assigned_user": "'"$userId"'"}'

curl --request PATCH \
--url "$baseUrl/api/v1/hardware/$assetId" \
--header 'accept: application/json' \
--header "authorization: Bearer $apiKey" \
--header 'content-type: application/json' \
--data '{"status_id": 4}'
osascript -e 'display alert "your device has been successfully inventorized" message "success"'
exit
else
 exit
fi
fi