<<<<<<< HEAD
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



####################################################################################
# prompt for root account, as serial can't be read without root
# credit to Wolfgang Pavel
####################################################################################

if passwort=$(zenity --entry --hide-text --text "This script needs root permission:" --title "Please enter your password" 2> /dev/null); then
  if ! [ -z $passwort ]; then # enter password, not empty
    echo "$passwort" | sudo -S -i -k pwd > /dev/null 2> /dev/null
    if ! [ $? -eq 0 ]; then # Wrong password
      zenity --warning --no-wrap --text "Wrong password!" --title "Passwort" 2> /dev/null
      exit
    else # password right
      echo "$passwort" | sudo -S -i -k $@ dmidecode -t system   # get system data
      grep 'serial' | cut -d ":" -f2
      if ! [ $? -eq 0 ]; then #get system data failed
        exit
      fi
    fi
  else #leeres Passwort
    zenity --warning --no-wrap --text "Password empty, please type in a password" --title "Password" 2> /dev/null
    exit
  fi
fi



assetName=$(hostname)
#sysModel=$(system_profiler SPHardwareDataType | grep 'Model Name' | cut -d ":" -f2)
sysManufacturer="Apple"
#serialNumber=$(system_profiler SPHardwareDataType | grep 'Serial Number' | cut -d ":" -f2 | xargs)
#ramSize=$(system_profiler SPHardwareDataType | grep 'Memory' | cut -d ":" -f2)
diskSize=$(df -H | awk '/\/dev\/disk1s1/ {printf("%s\n", $2)}' | tr -d "G")
diskSize+=" GB"
#macAddress=$(networksetup -listallhardwareports | grep Wi-Fi -A 3 | awk '/Ethernet Address:/{print $3}'|xargs)
#sysFull=$(sysctl hw.model | cut -d ":" -f2 | tr -d "\t" | xargs)
#osName=$(sw_vers | grep 'ProductName'  | cut -d ":" -f2 | tr -d '\t') 
#osVer=$(sw_vers | grep 'ProductVersion'  | cut -d ":" -f2 | tr -d '\t') 
=======
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



####################################################################################
# prompt for root account, as serial can't be read without root
# credit to Wolfgang Pavel
####################################################################################

if passwort=$(zenity --entry --hide-text --text "This script needs root permission:" --title "Please enter your password" 2> /dev/null); then
  if ! [ -z $passwort ]; then # enter password, not empty
    echo "$passwort" | sudo -S -i -k pwd > /dev/null 2> /dev/null
    if ! [ $? -eq 0 ]; then # Wrong password
      zenity --warning --no-wrap --text "Wrong password!" --title "Passwort" 2> /dev/null
      exit
    else # password right
      echo "$passwort" | sudo -S -i -k $@ lshw -c system # get system data
      if ! [ $? -eq 0 ]; then #get system data failed
        exit
      fi
    fi
  else #leeres Passwort
    zenity --warning --no-wrap --text "Password empty, please type in a password" --title "Password" 2> /dev/null
    exit
  fi
fi



assetName=$(hostname)
#sysModel=$(system_profiler SPHardwareDataType | grep 'Model Name' | cut -d ":" -f2)
sysManufacturer="Apple"
#serialNumber=$(system_profiler SPHardwareDataType | grep 'Serial Number' | cut -d ":" -f2 | xargs)
#ramSize=$(system_profiler SPHardwareDataType | grep 'Memory' | cut -d ":" -f2)
diskSize=$(df -H | awk '/\/dev\/disk1s1/ {printf("%s\n", $2)}' | tr -d "G")
diskSize+=" GB"
#macAddress=$(networksetup -listallhardwareports | grep Wi-Fi -A 3 | awk '/Ethernet Address:/{print $3}'|xargs)
#sysFull=$(sysctl hw.model | cut -d ":" -f2 | tr -d "\t" | xargs)
#osName=$(sw_vers | grep 'ProductName'  | cut -d ":" -f2 | tr -d '\t') 
#osVer=$(sw_vers | grep 'ProductVersion'  | cut -d ":" -f2 | tr -d '\t') 
>>>>>>> 1e38fb02b1d239d476f8ba1e6b41161f90f35558
os="$osName - $osVer"