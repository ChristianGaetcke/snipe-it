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