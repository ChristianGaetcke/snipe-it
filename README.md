# Snipe-IT Rest Api Clients


These clients were created out of lazyness and "cost efficiency" (read: stingyness), as I didn't want to manually inventorize the assets we already had and
I was not willing to pay for intunes or a similar solution, so this was the most reasonable approach. The user only needs administrative rights on his/her
computer and can run everything.

## Getting Started

You´ll obviously need a working Snipe-IT installation and an API key. 
This will not be in the scope of this document, but there are some great tutorials
on how to get Snipe-IT running in Docker (https://snipe-it.readme.io/docs/docker) and create an API key.

### Prerequisites

The Windows10 client is pure powershell and uses forms (with a Base64 encoded Icon).
You don't need to add any modules, as it uses only existing Powershell commands. The only drawback is
an out of the box restricted execution policy, when it comes to downloaded powershell-scripts.
That's why I added the helper.bat, which will just call an elevated powershell.

For the OSX client, it is strongly advised to use Pashua (https://github.com/BlueM/Pashua - great work of @BlueM) 
and Playtpus (https://github.com/sveinbjornt/Platypus - great work of @sveinbjornt) to create an app out of the code.
You can run the whole thing as a script, but won't present the more or less neat UI.




### Preparing the Clients

The following table will show a list of the switches and what they do:

## Deployment

The Windows client should include the helper.bat to bypass the execution-policy, as most Windows installations will have a restricted execution policy. Just zip both files into a folder
and let the users unzip it to the desktop and run helper.bat. They'll get a prompt for insecure software. This can be bypassed by adding a valid certificate, which was beyond the scope of this project.

The OSX client 

## Built With

* [Visual Studio Code](https://code.visualstudio.com/) 
* [Snipe-IT] (https://snipeitapp.com/)


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Marco Blüm for Pashua
* Sveinbjorn Thordarson for Platypus
* Adam Bacon for the chassis-type code