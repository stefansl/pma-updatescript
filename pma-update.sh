#!/bin/bash

##
# SETTINGS
# Please check this settings. Without changing the 
# user and group your installation will possibly 
# not work!
##
LOCATION="" 	#directory where PMA is installed. without slash at the end. f.e. LOCATION="/var/www/" PMA location will be /var/www/pma
USER=""        	#User
GROUP=""       	#Group 
VERSIONLINK=http://www.phpmyadmin.net/home_page/version.php



##
# Don't change anything from here
##


# Check settings
if [  -z "$LOCATION" -o -z "$USER" -o -z "$GROUP" ];
then	
	echo "Check your settings, please. LOCATION, USER and/or GROUP variables are still empty!";
	exit 1;
fi

# Get the local installed version
if [ -f $LOCATION/pma/Documentation.txt ]
then
	VERSIONLOCAL=$(sed -ne '1p' $LOCATION/pma/Documentation.txt | cut -d' ' -f 2);
else
	echo "Did not found a working installation. Check your settings, please.";
	exit 1;
fi


# Get latest version
if [ $1 ]
then
	#If version parameter exists, use it
	VERSION=$1;
else
	# Find out latest version
	VERSION=$(wget -q -O  /tmp/phpMyAdmin_Update.html  $VERSIONLINK && sed -ne '1p' /tmp/phpMyAdmin_Update.html);
    
    #Check the versions
	if [ $VERSION == $VERSIONLOCAL ]
	then
		echo "Your phpMyAdmin installation is already the newest!";
		exit 0;
	fi
fi


#Start the update
if [ $VERSION ]
then
        cd $LOCATION;
 
        MYLOCATION=`pwd`;
 
        if [ $MYLOCATION != $LOCATION ]
        then
                echo "An error occured while changing the directory. Please check your settings! Your given directory: " $LOCATION;
                pwd;
 
        else
                wget --directory-prefix=$LOCATION http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/$VERSION/phpMyAdmin-$VERSION-all-languages.tar.bz2
                if [ -f "$LOCATION/phpMyAdmin-$VERSION-all-languages.tar.bz2" ]
                then    tar xjvf phpMyAdmin-$VERSION-all-languages.tar.bz2
                        mv -v $LOCATION/pma/config.inc.php $LOCATION/phpMyAdmin-$VERSION-all-languages/
                        rm -Rv $LOCATION/pma
                        mv -v $LOCATION/phpMyAdmin-$VERSION-all-languages $LOCATION/pma
                        chown -Rv $USER:$GROUP $LOCATION/pma
                        echo "I succesfully updated phpMyAdmin from version " $VERSIONLOCAL " to " $VERSION " in your directory " $LOCATION ". Enjoy!"
                else
                        echo "An error occured while downloading. I tried downloading from: http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/"$VERSION"/phpMyAdmin-"$VERSION"-all-languages.tar.bz2.";
                fi
        fi
else
    	echo "Something went wrong while detecting the newest Version of PMA. :( Maybe this link here is dead: $VERSIONLINK";
 
fi