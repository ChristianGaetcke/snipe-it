


## Preparing Snipe-IT and the Clients

### Building the OSX Client



Download [Platypus](https://github.com/sveinbjornt/Platypus) and [Pashua](https://github.com/BlueM/Pashua). 


Then edit the file 'inventory.sh' to at least contain the api-key and the Base-Url of your Snipe-IT installation.
```
apiKey=""    <-your Snipe-IT Key should go here>
baseUrl=""   <-your Snipe-IT Base URL should go here>
```

You can fully disable the GUI by changing `enableGUI="1"` to `enableGUI="0"`, but be aware, that the asset-tag will be pulled from the hostname, no user will be created and therefore no email will be assigned.

Additional to that, you can disable the manual entry of the asset tag, if you are sure your machines have been assigned the proper hostname while they were rolled out. To do that, you need to change `getTag="1"` to `getTag="0"`

Assuming you already have created the extra Fieldsets in Snipe-IT, you'll need to update them in `inventory.sh` as stated in the examples:

```
Fieldset-ID:																		
example: fsField = "2"															
CPU-Field:
example: cpuField = "_snipeit_cpu_4"
RAM-Field:
example: ramField = "_snipeit_ram_2"
Macaddress-Field:
example: macField = "_snipeit_mac_address_1"
Disk-Field:		
example: diskField = "_snipeit_disksize_3"
Operatingsystem-Field
example: osField = "_snipeit_operating_system_6"
$statusID is the status checked out assets will be transferred to
example: statusID = "2"
```

As soon as you have added the necessary values to `inventory.sh` it is time to use pashua and inspect the package itself. You'll want to extract the following files to your desktop: `pashua.sh`

For convenience I already added a fully packed client where I removed the additional icons and xml-files. (reducing the size of the app by nearly 800kB). You'll only need to inspect the folder `Invetory.app`, go to `Resources`and do the above mentioned changes to the file `script` and save everything. Then you can send the app directly to your users.

## Deployment



The OSX client 

