#!/bin/bash

STR=$(cat /etc/nginx/sites-available/nginx.conf)
AUTOINDEXON='autoindex on'
AUTOINDEXOFF='autoindex off'

if [[ "$STR" == *"$AUTOINDEXON"* ]]
then
	sed -i 's/autoindex on/autoindex off/' /etc/nginx/sites-available/nginx.conf
elif [[ "$STR" == *"$AUTOINDEXOFF"* ]]
then
	sed -i 's/autoindex off/autoindex on/' /etc/nginx/sites-available/nginx.conf
fi
service nginx restart
