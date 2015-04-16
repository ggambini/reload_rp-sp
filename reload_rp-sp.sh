#!/bin/sh

# Param + échange de clé
remote_rp="<addr_or_fqdn_remote-node>"

#
# Reload httpd
#
	# On check la conf local
	/usr/bin/printf "CONFIGTEST sur RP local... "
	service httpd configtest > /dev/null 2>&1
	if [[ $? -ge "1" ]]
        then
                /usr/bin/printf "ERREUR\n"
                exit 1
        else
                /usr/bin/printf "OK\n"
        fi

	# On reload le RP local
	/usr/bin/printf "RELOAD sur RP local... "
        service httpd reload > /dev/null
        if [[ $? -ge "1" ]]
        then
                /usr/bin/printf "ERREUR\n"
                exit 1
        else
                /usr/bin/printf "OK\n"
        fi

	# On synchronise la conf
	/usr/bin/printf "SYNC CONF sur RP distant... "
        rsync -e "ssh -i /root/.ssh/id_dsa" -r /etc/httpd/conf/* root@$remote_rp:/etc/httpd/conf > /dev/null
        if [[ $? -ge "1" ]]
        then
                /usr/bin/printf "ERREUR\n"
                exit 1
        else
                /usr/bin/printf "OK\n"
        fi

	# On reload le RP distant
	/usr/bin/printf "RELOAD sur RP distant... "
	ssh root@$remote_rp "service httpd reload" > /dev/null
	if [[ $? -ge "1" ]]
        then
                /usr/bin/printf "ERREUR\n"
                exit 1
        else
                /usr/bin/printf "OK\n"
        fi

#
# Reload shibd
#
	# On check la conf local -> xmlwf par exemple

	# On reload le RP local
        /usr/bin/printf "RELOAD sur SP local... "
        service shibd reload > /dev/null
        if [[ $? -ge "1" ]]
        then
                /usr/bin/printf "ERREUR\n"
                exit 1
        else
                /usr/bin/printf "OK\n"
        fi

	# On synchronise la conf
        /usr/bin/printf "SYNC CONF sur SP distant... "
        rsync -e "ssh -i /root/.ssh/id_dsa" -r /etc/shibboleth/* root@$remote_rp:/etc/shibboleth > /dev/null
        if [[ $? -ge "1" ]]
        then
                /usr/bin/printf "ERREUR\n"
                exit 1
        else
                /usr/bin/printf "OK\n"
        fi

	# On reload le RP distant
        /usr/bin/printf "RELOAD sur SP distant... "
        ssh root@$remote_rp "service shibd reload" > /dev/null
        if [[ $? -ge "1" ]]
        then
                /usr/bin/printf "ERREUR\n"
                exit 1
        else
                /usr/bin/printf "OK\n"
        fi

