## Windows client

Then edit the file 'inventory.ps1' to at least contain the api-key and the Base-Url of your Snipe-IT installation.
```
$apiKey=""    <-your Snipe-IT Key should go here>
$baseUrl=""   <-your Snipe-IT Base URL should go here>
```

Assuming you already have created the extra Fieldsets in Snipe-IT, you'll need to update them in `inventory.ps1` as stated in the examples:
```
Fieldset-ID:										
example: $fsField = "2"							
CPU-Field:										
example: $cpuField = "_snipeit_cpu_4"				
RAM-Field:										
example: $ramField = "_snipeit_ram_2"				
Macaddress-Field:									
example: $macField = "_snipeit_mac_address_1"		
Disk-Field:										
example: $diskField = "_snipeit_disksize_3"		
Operatingsystem-Field								
example: $osField = "_snipeit_operating_system_6"	
$statusID is the status checked out assets will be transferred to		
example: $statusID = "2"								
```
and leave everything else as it is. 

If you want your users to type in the asset tag manually, change `$getTag=0` to `$getTag=0`.
If you want to disable the GUI, change `$enableGUI=1` to `$enableGUI=2` (This will only inventorize the asset without a user)

Then save everything and zip the folder and send it out to your users.

After running the batch-file, your users will see this, if you enabled manual setting of the asset-name:
![Snipe-IT asset manual](../../img/winclient-asset.JPG)

And this, if you disabled it:

![Snipe-IT asset auto](../../img/winclient-no-asset.JPG)

