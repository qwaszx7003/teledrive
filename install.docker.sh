#!/bin/bash

if [ ! -f docker/.env ]
then
  echo "Generating .env file..."

  ENV="develop"

  echo "Preparing your keys from https://my.telegram.org/"
  read -p "Enter your TG_API_ID: " TG_API_ID
  read -p "Enter your TG_API_HASH: " TG_API_HASH

  echo
  read -p "Enter your ADMIN_USERNAME: " ADMIN_USERNAME
  read -p "Enter your PORT: " PORT
  PORT="${PORT:=4000}"

  DB_PASSWORD=$(openssl rand -hex 18)
  API_JWT_SECRET=$(openssl rand -base64 36)
  FILES_JWT_SECRET=$(openssl rand -base64 36)

  echo "ENV=$ENV" > docker/.env
  echo "PORT=$PORT" >> docker/.env
  echo "TG_API_ID=$TG_API_ID" >> docker/.env
  echo "TG_API_HASH=$TG_API_HASH" >> docker/.env
  echo "ADMIN_USERNAME=$ADMIN_USERNAME" >> docker/.env
  echo "DB_PASSWORD=$DB_PASSWORD" >> docker/.env
  echo "API_JWT_SECRET=$API_JWT_SECRET" >> docker/.env
  echo "FILES_JWT_SECRET=$FILES_JWT_SECRET" >> docker/.env

  cd docker
  docker-compose up -d
  sleep 2
  docker-compose up -d
else
  export $(cat docker/.env | xargs)
  cd docker
  docker-compose down
  docker-compose up --build --force-recreate -d
  sleep 2
  docker-compose up -d
  docker image prune -f
fi
