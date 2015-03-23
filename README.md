# Unattended TTC Ubuntu ISO Maker

This simple script will create an unattended TTC Ubuntu ISO from start to finish. It will ask you a few questions once, and embed
your answers into a remastered ISO file for you to use over and over again.

This script creates a 100% original Ubuntu installation; no additional software is added, not even an ```apt-get update``` is
performed. You have all the freedom in the world to customize your Ubuntu installation whichever way you see fit. This script
just takes the pain out of re-installing Ubuntu over and over again.

## Compatibility

The script supports the following Ubuntu editions out of the box:

* Ubuntu 12.04.4 Server LTS amd64 - Precise Pangolin
* Ubuntu 14.04 Server LTS amd64 - Trusty Tahr

This script has been tested on and with these two versions as well, but there is no reason why it shouldn't work with other Ubuntu
editions. Other editions would require minor changes to the script though.

## Usage

* From your command line, run the following commands:

```
$ wget https://raw.githubusercontent.com/Tolsma/ubuntu-unattended/master/create-iso.sh -O ./create-iso.sh
$ chmod +x create-iso.sh
$ sudo ./create-iso.sh
```

* Choose which version you would like to remaster:

```
 +---------------------------------------------------+
 |            UNATTENDED UBUNTU ISO MAKER            |
 +---------------------------------------------------+

 which ubuntu edition would you like to remaster:

  [1] Ubuntu 12.04.4 LTS Server amd64 - Precise Pangolin
  [2] Ubuntu 14.04 LTS Server amd64 - Trusty Tahr

 please enter your preference: [1|2]:
```

* Enter your github source location voor your config; the default is *https://github.com/Tolsma/ubuntu-unattended*:

```
 please enter your preferred timezone: https://github.com/Tolsma/ubuntu-unattended
```

* Enter your desired timezone; the default is *Europe/Amsterdam*:

```
 please enter your preferred timezone: Europe/Amsterdam
```

* Enter your desired username; the default is *sander*:

```
 please enter your preferred username: sander
```

* Enter the password for your user account; the default is *empty*

```
 please enter your preferred password:
```

* Confirm your password:

```
 confirm your preferred password:
```

* Sit back and relax, while the script does the rest! :)

## What it does

This script does a bunch of stuff, here's the quick walk-through:

* It asks you for your preferences regarding the unattended ISO
* Downloads the appropriate Ubuntu original ISO straight from the Ubuntu servers; if a file with the exact name exists, it will
  use that instead (so it won't download it more than once if you are creating several unattended ISO's with different defaults)
* Downloads the netson preseed file; this file contains all the magic answers to auto-install ubuntu. It uses the following
  defaults for you (only showing most important, for details, simply check the seed file in this repository):
 * Language/locale: en_US
 * Keyboard layout: US International
 * Root login disabled (so make sure you write down your default usernames' password!)
 * Partitioning: LVM, full disk, single partition
* Install the mkpasswd program (part of the whois package) to generate a hashed version of your password
* Install the genisoimage program to generate the new ISO file
* Mount the downloaded ISO image to a temporary folder
* Copy the contents of the original ISO to a working directory
* Set the default installer language
* Add/update the preseed file
* Add the autoinstall option to the installation menu
* Generate the new ISO file
* Cleanup
* Show a summary of what happended:

```
 installing required packages
 remastering your iso file
 creating the remastered iso
 -----
 finished remastering your ubuntu iso file
 the new file is located at: /tmp/ubuntu-14.04-server-amd64-unattended.iso
 your username is: sander
 your password is:
 your hostname is: ubuntu
 your timezone is: Europe/Amsterdam
```

### Once Ubuntu is installed...

It fires off the start.sh script in your users' home directory to complete the installation. This will ask you all system info
required to handle final system configuration.

```$ sudo ~/start.sh```

## License
MIT