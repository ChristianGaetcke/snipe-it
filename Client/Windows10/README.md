# Snipe-IT Rest Api Clients


## Preparing Snipe-IT and the Clients

### Snipe-IT

You'll need to create some fieldsets in Snipe-IT for these clients to work properly. For a proper inventorization I choose the CPU, Disksize, Ramsize, Primary Macaddress and the OS.
These fields need to be added to the client-scripts, as they aren't standartized. The names of the fields need to be pulled from Snipe-IT => Custom Fields => DB Field and then inserted into the clients.

![Snipe-IT Fieldsets](../img/snipeit-fieldsets.JPG)

Afterwards you'll need to get the ID of the fieldset you want to assign to your assets. (You can find it by going to your custom fieldsets => open the fieldset itself=>last number of the URL is the fieldset ID).

![Snipe-IT Fieldset ID](../img/fieldset-id.JPG)

Last but not least, you'll need to get the status-id of the status you want to have after the device is checked out. This can be found under Status Labels => edit the status label => last number of the URL is the status-ID).

![Snipe-IT Statuslabel](../img/statuslabel.JPG)

### Windows client

Just define the parameters by following the examples in inventory.ps1
```
$apiKey = ''
$baseUrl = ""
$fsField = ""
$cpuField = ""
$ramField = ""
$macField = ""
$diskField = ""
$osField = ""
$statusID = ""
```
and leave everything else as it is. 
If you want your users to type in the asset tag manually, change `$getTag=0` to `$getTag=0`.
If you want to disable the GUI, change `$enableGUI=1` to `$enableGUI=2` (This will only inventorize the asset without a user)

Then save everything and zip the folder and send it out to your users.

After running the batch-file, your users will see this, if you enabled manual setting of the asset-name:
![Snipe-IT asset manual](img/winclient-asset.JPG)

And this, if you disabled it:

![Snipe-IT asset auto](img/winclient-no-asset.JPG)

