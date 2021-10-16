#!/usr/bin/bash

echo "Modifying baseURL ..."
if [[ $ENV == "prod" || $ENV == "staging" ]]; then
  echo "New baseURL: https://$DOMAIN_NAME";
  #sed -i 's/baseURL=.*/baseURL="https\:\/\/'$DOMAIN_NAME'"/g' config.toml;
else
  echo "New baseURL: http://$SERVER_IP";
  sed -i 's/baseURL=.*/baseURL="http\:\/\/'$SERVER_IP'"/g' config.toml;
fi
echo "baseURL has been applied!"
