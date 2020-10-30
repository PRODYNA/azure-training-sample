#!/bin/bash
PUB_IP="$( dig @ns1-1.akamaitech.net ANY whoami.akamai.net +short )"

sudo apt-get update
sudo apt-get -y install apt-transport-https ca-certificates curl software-properties-common

# Add apt repos
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
sudo add-apt-repository \
   "deb [arch=amd64] https://download.docker.com/linux/ubuntu \
   $(lsb_release -cs) \
   stable"

# Install Docker
sudo apt-get -y install docker-ce

echo -n "\n\nEnter DB URL [ENTER]: "
read db_url

echo -n "Enter DB username [ENTER]: "
read db_user

echo -n "Enter DB password [ENTER]: "
read -s db_pass

echo "\n\nCreating database 'wordpress' on MySQL server..."
echo "create database wordpress" | mysql --host=$db_url --user=$db_user --password=$db_pass
echo "Database created!"

echo "Starting Wordpress server.."
sudo docker run -d -e WORDPRESS_DB_HOST=$db_url -e WORDPRESS_DB_USER=$db_user -e WORDPRESS_DB_PASSWORD=$db_pass -e WORDPRESS_DB_NAME=wordpress -e WORDPRESS_TABLE_PREFIX=wp_ --network host wordpress

echo "Access Wordpress via http://$PUB_IP"