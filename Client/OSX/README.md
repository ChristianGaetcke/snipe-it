


## Preparing Snipe-IT and the Clients

### Building the OSX Client


Download [Platypus](https://github.com/sveinbjornt/Platypus) and [Pashua](https://github.com/BlueM/Pashua). 


Then edit the file 'inventory.sh' to at least contain the api-key and the Base-Url of your Snipe-IT installation.
```
apiKey=""    <-your Snipe-IT Key should go here>
baseUrl=""   <-your Snipe-IT Base URL should go here>
```

You can fully disable the GUI by changing ´´enableGUI="1"´´ to ´´enableGUI="0"´´, but be aware, that the asset-tag will be pulled from the hostname, no user will be created and therefore no email will be assigned.

Additional to that, you can disable the manual entry of the asset tag, if you are sure your machines have been assigned the proper hostname while they were rolled out. To do that, you need to change ´´getTag="1"´´ to ´´getTag="0"´´

## Deployment



The OSX client 

