# phpMyAdmin updatescript for your shell
With this script it will be easy to update to phpMyAdmin's latest version. Directly from your shell.

## Requirements
- wget
- tar
- bzip2

## Installation
Copy the script to any location of your machine.   
IMPORTANT: Open it and correct the settings.

## Settings

You need to set at least LOCATION, PMA, USER and GROUP. If you set f.e. LOCATION="/var/www" and PMA="pma" your PMA
installation will be installed into "/var/www/pma".

## Usage
For installing the latest version start the script like this (in a cronjob if you want)

    ./pma-update.sh

If you want to install a specified version

    ./pma-update.sh 3.5.0


 
