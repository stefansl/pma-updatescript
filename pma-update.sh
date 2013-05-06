#!/bin/sh

##
# SETTINGS
# Please check this settings. Without changing the
# user and group your installation will possibly
# not work!
##
LOCATION=""     #directory where PMA is installed. without slash at the end. f.e. LOCATION="/var/www"
PMA=""          #name of the phpmyadmin folder. f.e. pma or phpMyAdmin
USER=""         #User
GROUP=""        #Group
LOGLEVEL=1      #set 0 for quiet mode (no output)
                #set 1 to output warnings (DEFAULT)
                #set 2 to output all messages
VERSIONLINK="http://www.phpmyadmin.net/home_page/version.php"

##
# Don't change anything from here
##

# output warnings
function log() {
    if [ LOGLEVEL > 0 ]; then
        echo "$@";
    fi
}

# output additional messages
function info() {
    if [ LOGLEVEL == 2 ]; then
        echo "$@";
    fi
}

# Check settings
if [ -z "$LOCATION" -o -z "$PMA" -o -z "$USER" -o -z "$GROUP" ]; then
    log "Check your settings, please. LOCATION, PMA, USER and/or GROUP variables are still empty!";
    exit 1;
fi

# Get the local installed version
if [ -f $LOCATION/$PMA/README ];
then
    VERSIONLOCAL=$(sed -n 's/^Version \(.*\)$/\1/p' $LOCATION/$PMA/README);
    info "Found local installation version" $VERSIONLOCAL;
else
    log "Did not found a working installation. Check your settings, please.";
    exit 1;
fi

# Get latest version
if [ -n "$1" ]; then
    #If version parameter exists, use it
    VERSION=$1;

    #Check the versions
    if [ $VERSION = $VERSIONLOCAL ]; then
        info "phpMyAdmin $VERSIONLOCAL is installed already!";
        exit 0;
    fi
else
    # Find out latest version
    VERSION=$(wget -q -O /tmp/phpMyAdmin_Update.html $VERSIONLINK && sed -ne '1p' /tmp/phpMyAdmin_Update.html);

    #Check the versions
    if [ $VERSION = $VERSIONLOCAL ]; then
        info "Your phpMyAdmin installation is already the newest!";
        exit 0;
    fi
fi

#Set output parameters
WGETLOG="-q";
TARLOG="xjf";
VERBOSELOG=""
if [ LOGLEVEL == 2 ]; then
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
        wget $WGETLOG --directory-prefix=$LOCATION http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/$VERSION/phpMyAdmin-$VERSION-all-languages.tar.bz2
        if [ -f "$LOCATION/phpMyAdmin-$VERSION-all-languages.tar.bz2" ]
        then
            tar $TARLOG phpMyAdmin-$VERSION-all-languages.tar.bz2
            mv $VERBOSELOG $LOCATION/$PMA/config.inc.php $LOCATION/phpMyAdmin-$VERSION-all-languages/
            rm -R $VERBOSELOG $LOCATION/$PMA
            mv $VERBOSELOG $LOCATION/phpMyAdmin-$VERSION-all-languages $LOCATION/$PMA
            chown -R $VERBOSELOG $USER:$GROUP $LOCATION/$PMA
            # Remove downloaded package
            rm $VERBOSELOG phpMyAdmin-$VERSION-all-languages.tar.bz2
            # Remove setup-folder for security issues
            rm -R $VERBOSELOG $LOCATION/$PMA/setup
            # Remove examples-folder
            rm -R $VERBOSELOG $LOCATION/$PMA/examples
            log "I succesfully updated phpMyAdmin from version $VERSIONLOCAL to $VERSION in your directory $LOCATION. Enjoy!"
        else
            log "An error occured while downloading. I tried downloading from: http://downloads.sourceforge.net/project/phpmyadmin/phpMyAdmin/$VERSION/phpMyAdmin-$VERSION-all-languages.tar.bz2.";
        fi
    fi
else
    log "Something went wrong while detecting the newest Version of phpMyAdmin. :( Maybe this link here is dead: $VERSIONLINK";
fi