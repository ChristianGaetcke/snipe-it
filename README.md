# Snipe-IT Rest Api Clients


These clients were created out of lazyness and "cost efficiency" (read: stingyness), as I didn't want to manually inventorize the assets we already had and
I was not willing to pay for intunes or a similar solution, so this was the most reasonable approach.

## Getting Started

You´ll obviously need a working Snipe-IT installation and an API key. 
This will not be in the scope of this document, but there are some great tutorials
on how to get Snipe-IT running in Docker (https://snipe-it.readme.io/docs/docker).

### Prerequisites

The Windows10 client is pure powershell and uses forms (with a Base64 encoded Icon).
You don't need to add any modules, as it uses only existing Powershell commands. The only drawback is
an out of the box restricted execution policy, when it comes to downloaded powershell-scripts.
That's why I added the helper.bat, which will just call an elevated powershell.

For the OSX client, it is strongly advised to use Pashua (https://github.com/BlueM/Pashua - great work of @BlueM) 
and Playtpus (https://github.com/sveinbjornt/Platypus - great work of @sveinbjornt) to create an app out of the code.


```
Give examples
```

### Installing

A step by step series of examples that tell you how to get a development env running

Say what the step will be

```
Give the example
```

And repeat

```
until finished
```

End with an example of getting some data out of the system or using it for a little demo



## Deployment

The Windows client should include the helper.bat to bypass the execution-policy, as most Windows installations will have a restricted execution policy. Just zip both files into a folder
and let the users unzip it to the desktop and run helper.bat. They'll get a prompt for insecure software. This can be bypassed by adding a valid certificate, which was beyond the scope of this project.

The OSX client 

## Built With

* [Visual Studio Code](https://code.visualstudio.com/) - The web framework used


## License

This project is licensed under the MIT License - see the [LICENSE.md](LICENSE.md) file for details

## Acknowledgments

* Hat tip to anyone whose code was used
* Inspiration
* etc
