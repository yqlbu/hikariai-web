#!/usr/bin/bash

echo "Modifying baseURL ..."
if [[ $ENV == "prod" || $ENV == "staging" ]]; then
  echo "New baseURL: https://$DOMAIN_NAME"
  sed -i 's/baseURL=.*/baseURL="https\:\/\/'$DOMAIN_NAME'"/g' config.toml
  echo "baseURL has been applied!"
else
  echo "ENV not exists, operation aborted!"
fi
