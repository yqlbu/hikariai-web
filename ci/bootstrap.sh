#!/usr/bin/sh

echo "Modifying baseURL ..."
if [[ $ENV == "prod"  ]]; then
  echo "New baseURL: https://$DOMAIN_NAME";
else
  echo "New baseURL: http://$SERVER_IP";
  sed -i 's/baseURL=.*/baseURL="http\:\/\/'$SERVER_IP'"/g' config.toml;
fi
echo "baseURL has been applied!"
