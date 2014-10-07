# phpMyAdmin updatescript for your shell
This script will update your current phpMyAdmin to the latest version directly from your shell.

## Requirements
- wget
- tar
- bzip2

## Installation
Copy the script to any location of your machine.   
IMPORTANT: You need to edit the script to set the correct settings.

## Settings

You need to set the variables LOCATION, PMA, USER and GROUP. If you set f.e. LOCATION="/var/www" and PMA="pma" your PMA
installation will be installed into "/var/www/pma".

## Usage
For updating phpMyAdmin to the latest version, execute the shell script like this:

    ./pma-update.sh

If you want to install a specified version

    ./pma-update.sh 3.5.0


 
