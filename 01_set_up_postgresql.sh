#!/bin/bash

if [[ $UID -ne 0 ]]; then
    echo "$0 must be run as root"
    exit 1
fi

# This assumes you ran step 00 (attach an EBS)

apt-get update && apt-get install -y postgresql postgis
/etc/init.d/postgresql stop
mkdir /mnt/postgresql
sed -i "s/data_directory = '\/var\/lib\/postgresql\/9.3\/main'/data_directory = '\/mnt\/postgresql\/9.3\/main'/" /etc/postgresql/9.3/main/postgresql.conf
mv /var/lib/postgresql/9.3 /mnt/postgresql/
chown -R postgres:postgres /mnt/postgresql
/etc/init.d/postgresql start

sudo -u postgres psql -c "CREATE ROLE census WITH NOSUPERUSER LOGIN UNENCRYPTED PASSWORD 'censuspassword';"
sudo -u postgres psql -c "CREATE DATABASE census WITH OWNER census;"

# Make login passwordless
echo "localhost:5432:census:census:censuspassword" > /home/ubuntu/.pgpass
chmod 0600 /home/ubuntu/.pgpass
