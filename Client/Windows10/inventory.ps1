#################################################################################################
# Scripted by: Christian Gätcke 								#
# Created on: 02/07/2020  									#
#################################################################################################


#####################################
# automatically get asset tag?      #
# yes: $getTag=0                    #
# no : $getTag=1                    #
#####################################
$getTag=0

#########################################
# enable the GUI?                       #
# yes: $enableGUI=1                     #
# powershell only : $enableGUI= 0       #
# only inventorize asset: $enableGUI= 2 #
# This will not create a user           #
#########################################
$enableGUI=1

##########################################################
# Global variables					 #
# $apiKey = '' your SnipeIt API Key			 #
# example:						 #
# $apiKey = '.......iIsImp0aSI6IjJmMDkyNDg5MzZk....'     #
# 							 #
# $baseUrl = '' the Base-Url of your SnipeIT installation#
# example:						 #
# $baseUrl = 'https://snipeit.example.com'		 #
##########################################################

$apiKey = ''
$header = @{'authorization'='Bearer ' + $apiKey ;'accept' = 'application/json' ; 'content-type' = 'application/json'}
$baseUrl = ""


#########################################################################################
# Snipe specific fields:								#
# To store values like Ram, CPU, Mac etc, a fieldset with 				#
# the corresponding fields needs to be created in snipe.  				#
# See: https://snipe-it.readme.io/docs/custom-fields#common-custom-fields-regexes	#
# Fieldset-ID:										#
# example: $fsField = "2"								#
# CPU-Field:										#
# example: $cpuField = "_snipeit_cpu_4"							#
# RAM-Field:										#
# example: $ramField = "_snipeit_ram_2"							#
# Macaddress-Field:									#
# example: $macField = "_snipeit_mac_address_1"						#
# Disk-Field:										#
# example: $diskField = "_snipeit_disksize_3"						#
# Operatingsystem-Field									#
# example: $osField = "_snipeit_operating_system_6"					#
# The examples won't work out of the box and need to be generated first			#
# 											#
# $statusID is the status checked out assets will be transferred to			#
# example: $statusID = "2"								#
#########################################################################################

$fsField = "2"
$cpuField = "_snipeit_cpu_4"
$ramField = "_snipeit_ram_2"
$macField = "_snipeit_mac_address_1"
$diskField = "_snipeit_disksize_3"
$osField = "_snipeit_operating_system_6"
$statusID = "2"


####################
#generate Random PW#
#of length 12	   #
####################
$ranPass = (-join ((65..90) + (97..122) | Get-Random -Count 12 | ForEach-Object {[char]$_})).Trim()

#####################################################################################################################################################################################
#                                                                                   GetSystemInfo                                                                                   #
#####################################################################################################################################################################################

##################
#get Computername#
#will be used as #
#Asset Name	 #
##################
$computername = $env:computername


###################################
#get System Model and Manufacturer#
###################################
$sysModel = (Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -expand Model) -replace '\s','-'
$sysManufacturer = (Get-CimInstance -ClassName Win32_ComputerSystem | Select-Object -expand Manufacturer) -replace '\s','-'
$serialNumber = ( Get-WmiObject -Class Win32_BIOS).SerialNumber

########
#get OS#
########

$operatingSystem = (Get-WMIObject win32_operatingsystem | Select-Object -expand name).split('|')[0]
Select-Object -Property SystemType

#####
#CPU#
#####
$CPU = Get-CimInstance -ClassName Win32_Processor | Select-Object -ExcludeProperty "CIM*" -expand Name

##################
#Disksize in GB  # 
##################
$disksizeinbytes = Get-CimInstance -ClassName Win32_LogicalDisk -Filter "DriveType=3" |
  Measure-Object -Property Size -Sum |
    Select-Object -Property Property,Sum -expand Sum
$disksize = ([math]::Round($disksizeinbytes / 1073741824))
$disksize =[string]$disksize + ' GB'

###############
#Ramsize in GB#
###############
$ramsizeinbytes = Get-CimInstance win32_physicalmemory | Select-Object capacity -expand capacity | Measure-Object -Property capacity -Sum | Select-Object -Property Property,Sum -expand Sum 
$ramsize = [math]::Round($ramsizeinbytes / 1073741824) 
$ramsize = [string]$ramsize + ' GB'

####################
#primary MacAddress#
####################
$primaryMacaddress = Get-WmiObject win32_networkadapterconfiguration `
| Select-Object -Property @{name='IPAddress';Expression={($_.IPAddress[0])}},MacAddress,Description `
| Where-Object Description -notlike "Hyper-V*"  |  Where-Object IPAddress -NE $null  | Select-Object -expand MacAddress

if ($primaryMacaddress.Length -lt 17) {
$primaryMacaddress = $primaryMacaddress[0]
} else 
{$primaryMacaddress = $primaryMacaddress}

#################################################################################################
# Credits go to:										#
# Scripted by: Adam Bacon  									#
# Created on: 15/03/2011  									#
# Scripted in: Powershell will work in V1 & V2 of Powershell					#
# See: https://gallery.technet.microsoft.com/scriptcenter/c0bc039d-5bbf-4c8b-8307-e44da22a42b5	#
#################################################################################################
function check-chassis {  
    BEGIN {}  
    PROCESS {  
              
            $chassis = Get-WmiObject win32_systemenclosure -computer "localhost" | Select-Object chassistypes  
            if ($chassis.chassistypes -contains '3'){Write-Output "Desktop" }  
            elseif ($chassis.chassistypes -contains '4'){Write-Output "Low Profile Desktop"}  
            elseif ($chassis.chassistypes -contains '5'){Write-Output "Pizza Box"}  
            elseif ($chassis.chassistypes -contains '6'){Write-Output "Mini Tower"}  
            elseif ($chassis.chassistypes -contains '7'){Write-Output "Tower"}  
            elseif ($chassis.chassistypes -contains '8'){Write-Output "Portable"}  
            elseif ($chassis.chassistypes -contains '9'){Write-Output "Laptop"}  
            elseif ($chassis.chassistypes -contains '10'){Write-Output "Notebook"}  
            elseif ($chassis.chassistypes -contains '11'){Write-Output "Hand Held"}  
            elseif ($chassis.chassistypes -contains '12'){Write-Output "Docking Station"}  
            elseif ($chassis.chassistypes -contains '13'){Write-Output "All in One"}  
            elseif ($chassis.chassistypes -contains '14'){Write-Output "Sub Notebook"}  
            elseif ($chassis.chassistypes -contains '15'){Write-Output "Space-Saving"}   
            elseif ($chassis.chassistypes -contains '16'){Write-Output "Lunch Box"}  
            elseif ($chassis.chassistypes -contains '17'){Write-Output "Main System Chassis"}  
            elseif ($chassis.chassistypes -contains '18'){Write-Output "Expansion Chassis"}  
            elseif ($chassis.chassistypes -contains '19'){Write-Output "Sub Chassis"}  
            elseif ($chassis.chassistypes -contains '20'){Write-Output "Bus Expansion Chassis"}  
            elseif ($chassis.chassistypes -contains '21'){Write-Output "Peripheral Chassis"}  
            elseif ($chassis.chassistypes -contains '22'){Write-Output "Storage Chassis"}  
            elseif ($chassis.chassistypes -contains '23'){Write-Output "Rack Mount Chassis"}  
            elseif ($chassis.chassistypes -contains '24'){Write-Output "Sealed-Case PC"}  
            else {{Write-Output "unknown"}  }}}

$categoryName = $( check-chassis ).Trim()


#####################################################################################################################################################################################
#                                                                                   Inventorization                                                                                 #
#####################################################################################################################################################################################

if ($enableGUI -eq "2") {
$manufactJson = Invoke-RestMethod -Uri "$baseUrl/api/v1/manufacturers?search=$sysManufacturer" -Headers $header -Method GET
$manufactJson = $manufactJson | Select-Object -ExpandProperty rows
$manufact = ( $manufactJson | Select-Object -expand "name" )
    if ($sysManufacturer -eq $manufact)
    {$manId = $manufactJson.id } else {
    $JSON = @{"name" = $sysManufacturer} | ConvertTo-Json
    Invoke-RestMethod -Uri $baseUrl/api/v1/manufacturers -Headers $header -Method POST -Body $JSON
    $manId = Invoke-RestMethod -Uri "$baseUrl/api/v1/manufacturers?search=$sysManufacturer" -Headers $header -Method GET | Select-Object -ExpandProperty rows | Select-Object -expand id}
$catJson = Invoke-RestMethod -Uri "$baseUrl/api/v1/categories?search=$categoryName" -Headers $header -Method GET
$catJson = $catJson | Select-Object -ExpandProperty rows
$cat = ( $catJson | Select-Object -expand "name" )
    if ($categoryName -eq $cat)
    {$categoryId = $catJson.id } else {
    $JSON = @{"name" = $categoryName ; "category_type" = "asset" ;  "checkin_email" = 'false' } | ConvertTo-Json
    Invoke-RestMethod -Uri $baseUrl/api/v1/categories -Headers $header -Method POST -Body $JSON
    $categoryId = Invoke-RestMethod -Uri "$baseUrl/api/v1/categories?search=$categoryName" -Headers $header -Method GET | Select-Object -ExpandProperty rows | Select-Object -expand id}
$modelJson = Invoke-RestMethod -Uri "$baseUrl/api/v1/models?limit=50&offset=0&search=$sysModel" -Headers $header -Method GET
$modelJson = $modelJson | Select-Object -ExpandProperty rows
$model = ( $modelJson | Select-Object -expand "name" )
    if ($sysModel -eq $model)
    {$modelId = $modelJson.id } else {
    $JSON = @{"name" = $sysModel ; "manufacturer_id" =$manId ; "category_id" = $categoryId ; "fieldset_id" = $fsField} | ConvertTo-Json
    Invoke-RestMethod -Uri "$baseUrl/api/v1/models" -Headers $header -Method POST -Body $JSON
    $modelId = Invoke-RestMethod -Uri $baseUrl/api/v1/models?search=$sysModel -Headers $header -Method GET | Select-Object -ExpandProperty rows | Select-Object -expand id
    }
$assetJson = Invoke-RestMethod -Uri "$baseUrl/api/v1/hardware?search=$serialNumber" -Headers $header -Method GET
$assetJson = $assetJson | Select-Object -ExpandProperty rows
$assets = ( $assetJson | Select-Object -expand "serial" )
    if ($serialNumber -eq $assets)
    {Write-Output "Asset already exists"
    } else {
        $JSON = @{"name" = $computername ; "status_id" = $statusID ; "model_id" = $modelId ; $ramField = $ramsize; $cpuField = $CPU ; $diskField = $disksize ; "serial" = $serialNumber ; $macField = $primaryMacaddress ; $osField = $operatingSystem } | ConvertTo-Json
        Invoke-RestMethod -Uri "$baseUrl/api/v1/hardware" -Headers $header -Method POST -Body $JSON
        Write-Output "Asset created"
        exit}}
else {
if ($enableGUI -eq "1") {
Add-Type -AssemblyName System.Windows.Forms
[System.Windows.Forms.Application]::EnableVisualStyles()
Add-Type -Name Window -Namespace Console -MemberDefinition '
[DllImport("Kernel32.dll")]
public static extern IntPtr GetConsoleWindow();

[DllImport("user32.dll")]
public static extern bool ShowWindow(IntPtr hWnd, Int32 nCmdShow);
'
$iconKey='iVBORw0KGgoAAAANSUhEUgAAACAAAAAgCAYAAABzenr0AAAABmJLR0
QA/wD/AP+gvaeTAAAAc0lEQVRYhe2XXQrAIAyDM/H+p5rn6p5k4gLK/Flh+UBQUJqGYhUQNwmALR
5nHfQo5jY/J0oZE7G1YSI0wbAoWDcSIAESIAESIAGsG+5qywCcOvCv9wBzIPO2FrKDVq0prh0YrY
Wu8y4d+OweSBviPT4mQlxtAyI4cVGDVAAAAABJRU5ErkJggg=='

$Form                            = New-Object system.Windows.Forms.Form
$Form.ClientSize                 = '379,221'
$Form.text                       = "Inventorization"
$Form.TopMost                    = $false

$iconBase64      = "$iconKey"
$iconBytes       = [Convert]::FromBase64String($iconBase64)
$stream          = New-Object IO.MemoryStream($iconBytes, 0, $iconBytes.Length)
$stream.Write($iconBytes, 0, $iconBytes.Length);
$Form.Icon       = [System.Drawing.Icon]::FromHandle((New-Object System.Drawing.Bitmap -Argument $stream).GetHIcon())

$emailAddress                      = New-Object system.Windows.Forms.TextBox
$emailAddress.multiline            = $false
$emailAddress.width                = 249
$emailAddress.height               = 20
$emailAddress.location             = New-Object System.Drawing.Point(62,34)
$emailAddress.Font                 = 'Microsoft Sans Serif,10'

$Label1                          = New-Object system.Windows.Forms.Label
$Label1.text                     = "Please enter your emailaddress"
$Label1.AutoSize                 = $true
$Label1.width                    = 25
$Label1.height                   = 10
$Label1.location                 = New-Object System.Drawing.Point(62,63)
$Label1.Font                     = 'Microsoft Sans Serif,10'

if ($getTag -eq "1") {
$compName                      = New-Object system.Windows.Forms.TextBox
$compName.multiline            = $false
$compName.width                = 249
$compName.height               = 20
$compName.location             = New-Object System.Drawing.Point(62,94)
$compName.Font                 = 'Microsoft Sans Serif,10'

$Label2                          = New-Object system.Windows.Forms.Label
$Label2.text                     = "Please enter your computername `naccording to the sticker at the bottom"
$Label2.AutoSize                 = $true
$Label2.width                    = 25
$Label2.height                   = 10
$Label2.location                 = New-Object System.Drawing.Point(62,123)
$Label2.Font                     = 'Microsoft Sans Serif,10'
}

$AddDeviceBtn                    = New-Object system.Windows.Forms.Button
$AddDeviceBtn.text               = "Add"
$AddDeviceBtn.width              = 60
$AddDeviceBtn.height             = 30
$AddDeviceBtn.location           = New-Object System.Drawing.Point(63,170)
$AddDeviceBtn.Font               = 'Microsoft Sans Serif,10'

$cancelBtn                       = New-Object system.Windows.Forms.Button
$cancelBtn.text                  = "Cancel"
$cancelBtn.width                 = 60
$cancelBtn.height                = 30
$cancelBtn.location              = New-Object System.Drawing.Point(251,170)
$cancelBtn.Font                  = 'Microsoft Sans Serif,10'
$Form.CancelButton   = $cancelBtn
$Form.Controls.Add($cancelBtn)
if ($getTag -eq "0")
{
$Form.controls.AddRange(@($emailAddress,$Label1,$compName,$Label2,$AddDeviceBtn,$cancelBtn))}
else {
$Form.controls.AddRange(@($emailAddress,$Label1,$compName,$Label2,$AddDeviceBtn,$cancelBtn))}

function Hide-Console
{
    $consolePtr = [Console.Window]::GetConsoleWindow()
    #0 hide
    [Console.Window]::ShowWindow($consolePtr, 0)
}



function addDevice {

$script:unameInput = $emailAddress.Text.Trim()
$script:assetTag = $compName.Text.Trim()


################################################################################################################################################
#To test this output, run:														       #
#echo $computername ,  $sysModel ,  $sysManufacturer ,  $CPU ,  $disksize ,  $ramsize ,  $primaryMacaddress ,  $operatingSystem , $serialNumber#
################################################################################################################################################

###########################################################
#call to your Snipe-instance: Does the manufacturer exist?#
#if not, create the manufacturer; 			  #
#else get the manufacturer's ID      			  #
###########################################################

$manufactJson = Invoke-RestMethod -Uri "$baseUrl/api/v1/manufacturers?search=$sysManufacturer" -Headers $header -Method GET
$manufactJson = $manufactJson | Select-Object -ExpandProperty rows
$manufact = ( $manufactJson | Select-Object -expand "name" )

	if ($sysManufacturer -eq $manufact)
	{
	$manId = $manufactJson.id } else {
	$JSON = @{"name" = $sysManufacturer} | ConvertTo-Json
	Invoke-RestMethod -Uri $baseUrl/api/v1/manufacturers -Headers $header -Method POST -Body $JSON
	$manId = Invoke-RestMethod -Uri "$baseUrl/api/v1/manufacturers?search=$sysManufacturer" -Headers $header -Method GET | Select-Object -ExpandProperty rows | Select-Object -expand id
	}

###########################################################
#call to your Snipe-instance: Does the category exist?	  #
#if not, create the category; 				  #
#else get the category's ID		      		  #
###########################################################
$catJson = Invoke-RestMethod -Uri "$baseUrl/api/v1/categories?search=$categoryName" -Headers $header -Method GET
$catJson = $catJson | Select-Object -ExpandProperty rows
$cat = ( $catJson | Select-Object -expand "name" )
    if ($categoryName -eq $cat)
    {$categoryId = $catJson.id } else {
    $JSON = @{"name" = $categoryName ; "category_type" = "asset" ;  "checkin_email" = 'false' } | ConvertTo-Json
    Invoke-RestMethod -Uri $baseUrl/api/v1/categories -Headers $header -Method POST -Body $JSON
    $categoryId = Invoke-RestMethod -Uri "$baseUrl/api/v1/categories?search=$categoryName" -Headers $header -Method GET | Select-Object -ExpandProperty rows | Select-Object -expand id}

###########################################################
#call to your Snipe-instance: Does the model exist?	  #
#if not, create the model; 				  #
#else get the model's ID		      		  #
###########################################################

$modelJson = Invoke-RestMethod -Uri "$baseUrl/api/v1/models?limit=50&offset=0&search=$sysModel" -Headers $header -Method GET
$modelJson = $modelJson | Select-Object -ExpandProperty rows
$model = ( $modelJson | Select-Object -expand "name" )


	if ($sysModel -eq $model)
	{
	$modelId = $modelJson.id } else {
	$JSON = @{"name" = $sysModel ; "manufacturer_id" =$manId ; "category_id" = $categoryId ; "fieldset_id" = $fsField} | ConvertTo-Json
	Invoke-RestMethod -Uri "$baseUrl/api/v1/models" -Headers $header -Method POST -Body $JSON
	$modelId = Invoke-RestMethod -Uri $baseUrl/api/v1/models?search=$sysModel -Headers $header -Method GET | Select-Object -ExpandProperty rows | Select-Object -expand id
	}



###########################################################
#call to your Snipe-instance: Does the asset exist?	  #
#if not, create the asset; 				  #
#else get the asset's ID		      		  #
#IMPORTANT: The serial number of the asset will be used   #
#to look the asset up. Make sure, your devices have a SN  #
#as older Boards sometimes don't propagate it		  #
###########################################################

$assetJson = Invoke-RestMethod -Uri "$baseUrl/api/v1/hardware?search=$serialNumber" -Headers $header -Method GET
$assetJson = $assetJson | Select-Object -ExpandProperty rows
$assets = ( $assetJson | Select-Object -expand "serial" )

	if ($serialNumber -eq $assets)
    {Write-Output "Asset already exists"
    $assetId = Invoke-RestMethod -Uri "$baseUrl/api/v1/hardware?search=$serialNumber" -Headers $header -Method GET | Select-Object -ExpandProperty rows | Select-Object -expand id
	} else {
    if ($getTag -eq "1") {
    $JSON = @{"name" = $computername ;"asset_tag" = $assetTag  ; "status_id" = $statusID ; "model_id" = $modelId ; $ramField = $ramsize; $cpuField = $CPU ; $diskField = $disksize ; "serial" = $serialNumber ; $macField = $primaryMacaddress ; $osField = $operatingSystem } | ConvertTo-Json
    } else {
    $JSON = @{"name" = $computername ; "status_id" = $statusID ; "model_id" = $modelId ; $ramField = $ramsize; $cpuField = $CPU ; $diskField = $disksize ; "serial" = $serialNumber ; $macField = $primaryMacaddress ; $osField = $operatingSystem } | ConvertTo-Json    
    }
	Invoke-RestMethod -Uri "$baseUrl/api/v1/hardware" -Headers $header -Method POST -Body $JSON
	$assetId = Invoke-RestMethod -Uri "$baseUrl/api/v1/hardware?search=$serialNumber" -Headers $header -Method GET | Select-Object -ExpandProperty rows | Select-Object -expand id
	 }
	

############################################################
#call to your Snipe-instance: Does the user exist?	   #
#if not, create the user and disallow login; 		   #
# >>"activated" = 'false'<<				   #
#else get the user's ID 		      		   #
#IMPORTANT: This script expects either name@example.com or #
#firstname.lastname@example.com as username.		   #
#I highly suggest to take the firstname.lastname approach  #
############################################################

$unameSplit = ($unameInput).split('@')[0]
	if (($unameSplit.ToCharArray() | Where-Object {$_ -eq '.'} | Measure-Object).Count -gt 0){
    $firstName = (($unameSplit).split(".")[0]).Trim()
    $lastName = (($unameSplit).split(".")[1]).Trim()
	} else {
	$firstName = $unameSplit.Trim() }

$userJson = Invoke-RestMethod -Uri "$baseUrl/api/v1/users?search=$unameInput" -Headers $header -Method GET
$userJson = $userJson | Select-Object -ExpandProperty rows
$users = ( $userJson | Select-Object -expand "username")
	if ($unameInput -eq $users) {
    Write-Output "user already exists"
    $userId = Invoke-RestMethod -Uri "$baseUrl/api/v1/users?search=$unameInput" -Headers $header -Method GET | Select-Object -ExpandProperty rows | Select-Object -expand id
	} else {
        if ($null -eq $lastname ){
	$JSON = @{"first_name" = $firstName ; "username" = $unameSplit ; "email" = $unameInput ; "password" = $ranPass ; "password_confirmation" = $ranPass ; "activated" = 'false' } | ConvertTo-Json
	Invoke-RestMethod -Uri "$baseUrl/api/v1/users" -Headers $header -Method POST -Body $JSON
    $userId = Invoke-RestMethod -Uri "$baseUrl/api/v1/users?search=$unameInput" -Headers $header -Method GET | Select-Object -ExpandProperty rows | Select-Object -expand id} else {
        $JSON = @{"first_name" = $firstName ; "last_name" = $lastName ; "username" = $unameSplit ; "email" = $unameInput ; "password" = $ranPass ; "password_confirmation" = $ranPass ; "activated" = 'false' } | ConvertTo-Json
        Invoke-RestMethod -Uri "$baseUrl/api/v1/users" -Headers $header -Method POST -Body $JSON
        $userId = Invoke-RestMethod -Uri "$baseUrl/api/v1/users?search=$unameInput" -Headers $header -Method GET | Select-Object -ExpandProperty rows | Select-Object -expand id    
    }
	 }

##########################################
# check out sasset to user        	 #
# and update the status and asset tag	 #
# if necessary	(e.g. if you change the  #
# sticker on the device			 #
##########################################

$JSON = @{ "checkout_to_type" = "user" ; "assigned_user" = $userId} | ConvertTo-Json
Invoke-RestMethod -Uri "$baseUrl/api/v1/hardware/$assetId/checkout" -Headers $header -Method POST -Body $JSON
$JSON = @{ "status_id" = 4 ; "asset_tag" = $assetTag } | ConvertTo-Json
Invoke-RestMethod -Uri "$baseUrl/api/v1/hardware/$assetId" -Headers $header -Method PATCH -Body $JSON


Add-Type -AssemblyName PresentationCore,PresentationFramework
$ButtonType = [System.Windows.MessageBoxButton]::OK
$MessageIcon = [System.Windows.MessageBoxImage]::Question
$MessageBody = "Your device has been inventorized!"
$MessageTitle = "success"
 
[System.Windows.MessageBox]::Show($MessageBody,$MessageTitle,$ButtonType,$MessageIcon)
 
$Form.Close()

	}
Hide-Console
$AddDeviceBtn.Add_Click({addDevice})
[void]$Form.ShowDialog()
}
else {
if ($getTag -eq "1") {
$unameInput = Read-Host -Prompt 'Please type in your emailaddress'
$assetTag = Read-Host -Prompt 'Please type in the name of your device/whats written on the sticker' }
else {
$unameInput = Read-Host -Prompt 'Please type in your emailaddress'  
}

###########################################################
#call to your Snipe-instance: Does the manufacturer exist?#
#if not, create the manufacturer; 			  #
#else get the manufacturer's ID      			  #
###########################################################
$manufactJson = Invoke-RestMethod -Uri "$baseUrl/api/v1/manufacturers?search=$sysManufacturer" -Headers $header -Method GET
$manufactJson = $manufactJson | Select-Object -ExpandProperty rows
$manufact = ( $manufactJson | Select-Object -expand "name" )
    if ($sysManufacturer -eq $manufact)
    {
    $manId = $manufactJson.id } else {
    $JSON = @{"name" = $sysManufacturer} | ConvertTo-Json
    Invoke-RestMethod -Uri $baseUrl/api/v1/manufacturers -Headers $header -Method POST -Body $JSON
    $manId = Invoke-RestMethod -Uri "$baseUrl/api/v1/manufacturers?search=$sysManufacturer" -Headers $header -Method GET | Select-Object -ExpandProperty rows | Select-Object -expand id
    }
###########################################################
#call to your Snipe-instance: Does the category exist?	  #
#if not, create the category; 				  #
#else get the category's ID      			  #
###########################################################
$catJson = Invoke-RestMethod -Uri "$baseUrl/api/v1/categories?search=$categoryName" -Headers $header -Method GET
$catJson = $catJson | Select-Object -ExpandProperty rows
$cat = ( $catJson | Select-Object -expand "name" )
    if ($categoryName -eq $cat)
    {$categoryId = $catJson.id } else {
    $JSON = @{"name" = $categoryName ; "category_type" = "asset" ;  "checkin_email" = 'false' } | ConvertTo-Json
    Invoke-RestMethod -Uri $baseUrl/api/v1/categories -Headers $header -Method POST -Body $JSON
    $categoryId = Invoke-RestMethod -Uri "$baseUrl/api/v1/categories?search=$categoryName" -Headers $header -Method GET | Select-Object -ExpandProperty rows | Select-Object -expand id}
###########################################################
#call to your Snipe-instance: Does the model exist?	  #
#if not, create the model; 				  #
#else get the model's ID		      		  #
###########################################################
$modelJson = Invoke-RestMethod -Uri "$baseUrl/api/v1/models?limit=50&offset=0&search=$sysModel" -Headers $header -Method GET
$modelJson = $modelJson | Select-Object -ExpandProperty rows
$model = ( $modelJson | Select-Object -expand "name" )
    if ($sysModel -eq $model)
    {
    $modelId = $modelJson.id } else {
    $JSON = @{"name" = $sysModel ; "manufacturer_id" =$manId ; "category_id" = $categoryId ; "fieldset_id" = $fsField} | ConvertTo-Json
    Invoke-RestMethod -Uri "$baseUrl/api/v1/models" -Headers $header -Method POST -Body $JSON
    $modelId = Invoke-RestMethod -Uri $baseUrl/api/v1/models?search=$sysModel -Headers $header -Method GET | Select-Object -ExpandProperty rows | Select-Object -expand id
    }
###########################################################
#call to your Snipe-instance: Does the asset exist?	  #
#if not, create the asset; 				  #
#else get the asset's ID		      		  #
#IMPORTANT: The serial number of the asset will be used   #
#to look the asset up. Make sure, your devices have a SN  #
#as older Boards sometimes don't propagate it		  #
###########################################################
$assetJson = Invoke-RestMethod -Uri "$baseUrl/api/v1/hardware?search=$serialNumber" -Headers $header -Method GET
$assetJson = $assetJson | Select-Object -ExpandProperty rows
$assets = ( $assetJson | Select-Object -expand "serial" )
    if ($serialNumber -eq $assets)
    {Write-Output "Asset already exists"
    $assetId = Invoke-RestMethod -Uri "$baseUrl/api/v1/hardware?search=$serialNumber" -Headers $header -Method GET | Select-Object -ExpandProperty rows | Select-Object -expand id
    } else {
    if ($getTag -eq "1") {
    $JSON = @{"name" = $computername ;"asset_tag" = $assetTag  ; "status_id" = $statusID ; "model_id" = $modelId ; $ramField = $ramsize; $cpuField = $CPU ; $diskField = $disksize ; "serial" = $serialNumber ; $macField = $primaryMacaddress ; $osField = $operatingSystem } | ConvertTo-Json
    } else {
        $JSON = @{"name" = $computername ; "status_id" = $statusID ; "model_id" = $modelId ; $ramField = $ramsize; $cpuField = $CPU ; $diskField = $disksize ; "serial" = $serialNumber ; $macField = $primaryMacaddress ; $osField = $operatingSystem } | ConvertTo-Json    
    }
    Invoke-RestMethod -Uri "$baseUrl/api/v1/hardware" -Headers $header -Method POST -Body $JSON
    $assetId = Invoke-RestMethod -Uri "$baseUrl/api/v1/hardware?search=$serialNumber" -Headers $header -Method GET | Select-Object -ExpandProperty rows | Select-Object -expand id
     }
$unameSplit = ($unameInput).split('@')[0]
    if (($unameSplit.ToCharArray() | Where-Object {$_ -eq '.'} | Measure-Object).Count -gt 0){
    $firstName = (($unameSplit).split(".")[0]).Trim()
    $lastName = (($unameSplit).split(".")[1]).Trim()
    } else {
    $firstName = $unameSplit.Trim() }
$userJson = Invoke-RestMethod -Uri "$baseUrl/api/v1/users?search=$unameInput" -Headers $header -Method GET
$userJson = $userJson | Select-Object -ExpandProperty rows
$users = ( $userJson | Select-Object -expand "username")
    if ($unameInput -eq $users) {
    Write-Output "user already exists"
    $userId = Invoke-RestMethod -Uri "$baseUrl/api/v1/users?search=$unameInput" -Headers $header -Method GET | Select-Object -ExpandProperty rows | Select-Object -expand id
    } else {
        if ($null -eq $lastname ){
    $JSON = @{"first_name" = $firstName ; "username" = $unameSplit ; "email" = $unameInput ; "password" = $ranPass ; "password_confirmation" = $ranPass ; "activated" = 'false' } | ConvertTo-Json
    Invoke-RestMethod -Uri "$baseUrl/api/v1/users" -Headers $header -Method POST -Body $JSON
    $userId = Invoke-RestMethod -Uri "$baseUrl/api/v1/users?search=$unameInput" -Headers $header -Method GET | Select-Object -ExpandProperty rows | Select-Object -expand id} else {
        $JSON = @{"first_name" = $firstName ; "last_name" = $lastName ; "username" = $unameSplit ; "email" = $unameInput ; "password" = $ranPass ; "password_confirmation" = $ranPass ; "activated" = 'false' } | ConvertTo-Json
        Invoke-RestMethod -Uri "$baseUrl/api/v1/users" -Headers $header -Method POST -Body $JSON
        $userId = Invoke-RestMethod -Uri "$baseUrl/api/v1/users?search=$unameInput" -Headers $header -Method GET | Select-Object -ExpandProperty rows | Select-Object -expand id    
    }}

$JSON = @{ "checkout_to_type" = "user" ; "assigned_user" = $userId} | ConvertTo-Json
Invoke-RestMethod -Uri "$baseUrl/api/v1/hardware/$assetId/checkout" -Headers $header -Method POST -Body $JSON
$JSON = @{ "status_id" = 4 ; "asset_tag" = $assetTag } | ConvertTo-Json
Invoke-RestMethod -Uri "$baseUrl/api/v1/hardware/$assetId" -Headers $header -Method PATCH -Body $JSON
exit
}}
