#!/bin/sh
##
# PHPMYADMIN UPDATE SCRIPT
# https://github.com/stefansl/pma-updatescript/
##

# SETTING
CRONPATH="/etc/cron.daily/pma-update"

# GO
installcron() {
	touch $CRONPATH
	echo "#!/bin/sh" >> $CRONPATH
	echo "sh $(pwd)/pma-update.sh" >> $CRONPATH
	echo "Cronjob for phpmyadmin updatescript installed."
	chmod 755 $CRONPATH
	break
}

for file in $CRONPATH ] ; do
	if [ -f $file ] ; then
		echo "Cronjob for pma-update already exists. Do you want to renew it? [y|N]"
		read answer
		if [ "$answer" = y -o "$answer" = Y ] ; then
			rm $CRONPATH
			installcron;
		else
			echo "Ok, I did nothing!"
			break		
		fi			
	else
		installcron;
	fi
done

