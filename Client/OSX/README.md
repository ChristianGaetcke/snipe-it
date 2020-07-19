


## Preparing Snipe-IT and the Clients

### Building the OSX Client

### OSX client

Download [Platypus](https://github.com/sveinbjornt/Platypus) and [Pashua](https://github.com/BlueM/Pashua). 

## Deployment

The Windows client should include the helper.bat to bypass the execution-policy, as most Windows installations will have a restricted execution policy. Just zip both files into a folder
and let the users unzip it to the desktop and run helper.bat. They'll get a prompt for insecure software. This can be bypassed by adding a valid certificate, which was beyond the scope of this project.

The OSX client 

## Some notes on the code

The code is far from perfect or optimized, but should serve as an inspiration for people who want to try out Snipe-IT or just want to do their inventorization and don't have the necessary environment.

## Built With

* [Visual Studio Code](https://code.visualstudio.com/) 
* [Snipe-IT](https://snipeitapp.com/)
* [Platypus](https://github.com/sveinbjornt/Platypus)
* [Pashua](https://github.com/BlueM/Pashua)

## License
BSD 3-Clause License

Copyright (c) 2020, Christian Gaetcke <cgaetcke@outlook.com>.
All rights reserved.

Redistribution and use in source and binary forms, with or without
modification, are permitted provided that the following conditions are met:

* Redistributions of source code must retain the above copyright notice, this
  list of conditions and the following disclaimer.

* Redistributions in binary form must reproduce the above copyright notice,
  this list of conditions and the following disclaimer in the documentation
  and/or other materials provided with the distribution.

* Neither the name of the copyright holder nor the names of its
  contributors may be used to endorse or promote products derived from
  this software without specific prior written permission.

THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS"
AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE
DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE
FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR
SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER
CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY,
OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE
OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.

## Acknowledgments

* Marco Blüm for Pashua
* Sveinbjorn Thordarson for Platypus
* Adam Bacon for the chassis-type code
