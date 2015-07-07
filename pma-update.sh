#!/bin/sh

##
# PHPMYADMIN-SCRIPT
# https://github.com/stefansl/pma-updatescript/
# Author: Stefan Schulz-Lauterbach, Michael Riehemann, Igor Buyanov
#
# SETTINGS
# Please check this settings. Without changing the
# user and group your installation will possibly
# not work!
##
LOCATION="" # Directory of PMA installation. Without a slash at the end. For example: LOCATION="/var/www"
PMA=""      # Name of the PMA folder. For example: pma or phpMyAdmin
LANGUAGE="" # Language of PMA. Leave it blank for all languages or specify a language pack, for example: english
USER=""     # User of files
GROUP=""    # Group of files
LOGLEVEL=1  # set 0 for quiet mode (no output)
            # set 1 to output warnings (DEFAULT)
            # set 2 to output all messages
VERSIONLINK="http://www.phpmyadmin.net/home_page/version.php"

##
# Don't change anything from here
##

# output warnings
log() {
    if [ $LOGLEVEL -gt 0 ]; then
        echo "$@";
    fi
}

# output additional messages
info() {
    if [ $LOGLEVEL -eq 2 ]; then
        echo "$@";
    fi
}

# Check settings
if [ -z "$LOCATION" -o -z "$PMA" -o -z "$USER" -o -z "$GROUP" ]; then
    log "Please, check your settings. The variables LOCATION, PMA, USER and/or GROUP are mandatory!";
    exit 1;
fi

if [ -z "$LANGUAGE"]; then
    LANGUAGE="all-languages"
fi

# Get the local installed version
if [ -f $LOCATION/$PMA/README ];
then
    VERSIONLOCAL=$(sed -n 's/^Version \(.*\)$/\1/p' $LOCATION/$PMA/README);
    info "Found local installation version" $VERSIONLOCAL;
else
    log "Did not found a working installation. Please, check the script settings.";
    exit 1;
fi

# Get latest version
if [ -n "$1" ]; then
    #If version parameter exists, use it
    VERSION=$1;

    #Check the versions
    if [ $VERSION = $VERSIONLOCAL ]; then
        info "phpMyAdmin $VERSIONLOCAL is already installed!";
        exit 0;
    fi
else
    # Find out latest version
    VERSION=$(wget -q -O /tmp/phpMyAdmin_Update.html $VERSIONLINK && sed -ne '1p' /tmp/phpMyAdmin_Update.html);

    #Check the versions
    if [ $VERSION = $VERSIONLOCAL ]; then
        info "You have the latest version of phpMyAdmin installed!";
        exit 0;
    fi
fi

#Set output parameters
WGETLOG="-q";
TARLOG="xjf";
VERBOSELOG=""
if [ $LOGLEVEL -eq 2 ]; then
    WGETLOG="-v";
    TARLOG="xjvf";
    VERBOSELOG="-v";
fi

#Start the update
if [ -n "$VERSION" ]; then
    cd $LOCATION;

    MYLOCATION=`pwd`;

    if [ $MYLOCATION != $LOCATION ]
    then
        log "An error occured while changing the directory. Please check your settings! Your given directory: $LOCATION";
        pwd;

    else
        wget $WGETLOG --directory-prefix=$LOCATION http://files.phpmyadmin.net/phpMyAdmin/$VERSION/phpMyAdmin-$VERSION-$LANGUAGE.tar.bz2
        if [ -f "$LOCATION/phpMyAdmin-$VERSION-$LANGUAGE.tar.bz2" ]
        then
            tar $TARLOG phpMyAdmin-$VERSION-$LANGUAGE.tar.bz2
            mv $VERBOSELOG $LOCATION/$PMA/config.inc.php $LOCATION/phpMyAdmin-$VERSION-$LANGUAGE/
            rm -R $VERBOSELOG $LOCATION/$PMA
            mv $VERBOSELOG $LOCATION/phpMyAdmin-$VERSION-$LANGUAGE $LOCATION/$PMA
            chown -R $VERBOSELOG $USER:$GROUP $LOCATION/$PMA
            # Remove downloaded package
            rm $VERBOSELOG phpMyAdmin-$VERSION-$LANGUAGE.tar.bz2
            # Remove setup-folder for security issues
            rm -R $VERBOSELOG $LOCATION/$PMA/setup
            # Remove examples-folder
            rm -R $VERBOSELOG $LOCATION/$PMA/examples
            log "PhpMyAdmin successfully updated from version $VERSIONLOCAL to $VERSION in $LOCATION. Enjoy!"
        else
            log "An error occured while downloading phpMyAdmin. Downloading unsuccessful from: http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/$VERSION/phpMyAdmin-$VERSION-$LANGUAGE.zip.";
        fi
    fi
else
    log "Something went wrong while getting the version of phpMyAdmin. :( Maybe this link here is dead: $VERSIONLINK";
fi
