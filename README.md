# phpMyAdmin updatescript for your shell
This script will update your current phpMyAdmin to the latest version directly from your shell.

## Requirements
- wget
- tar

## Installation
Copy the script to any location of your machine.   
IMPORTANT: You need to edit the script to set the correct settings.

If you want to install a cronjob, run
	
	sh install-cronjob.sh

## Settings

Open the file config.sh and edit the variables LOCATION, PMA. If you set f.e. LOCATION="/var/www" and PMA="pma" your PMA
installation will be installed into "/var/www/pma".

If you want, change the compression type - "tar.gz" and "tar.bz2" are possible.

## User based settings 

Instead of changing the settings in the script, you can place the variables in a user based .pma-updaterc file in the home folder from the user this script runs as.

## Usage
For updating phpMyAdmin to the latest version, execute the shell script like this:

    sh pma-update.sh

If you want to install a specific version

    sh pma-update.sh -r 3.5.0
    
    
### More options
    sh pma-update.sh [-hvf] [-r version]  
    -h    this help  
    -v    output all warnings  
    -f    force download, even if this version is installed already  
    -r version    choose a different version than the latest.  
    
