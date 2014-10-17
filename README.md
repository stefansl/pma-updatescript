# phpMyAdmin updatescript for your shell
This script will update your current phpMyAdmin to the latest version directly from your shell.

## Requirements
- wget
- tar
- bzip2

## Installation
Copy the script to any location of your machine.   
IMPORTANT: You need to edit the script to set the correct settings.

If you want to install a cronjob, run
	
	sh install-cronjob.sh

## Settings

Open the file config.sh and edit the variables LOCATION, PMA, USER and GROUP. If you set f.e. LOCATION="/var/www" and PMA="pma" your PMA
installation will be installed into "/var/www/pma".

If you want, change the compression type. "tar.bz2", "tar.gz" and "zip" are available.

## Usage
For updating phpMyAdmin to the latest version, execute the shell script like this:

    sh pma-update.sh

If you want to install a specified version

    sh pma-update.sh -r 3.5.0
    
### More options
    sh pma-update.sh [-hvf] [-r version]  
    -h    this help  
    -v    output all warnings  
    -f    force download, even if this version is installed already  
    -r version    choose a different version than the latest.  