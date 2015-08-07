#!/bin/bash

if [[ $UID -ne 0 ]]; then
    echo "$0 must be run as root"
    exit 1
fi

# This assumes you ran step 00 (attach an EBS)

apt-get update && apt-get install -y postgresql postgis
/etc/init.d/postgresql stop
mkdir /vol/postgresql
sed -i "s/data_directory = '\/var\/lib\/postgresql\/9.3\/main'/data_directory = '\/vol\/postgresql\/9.3\/main'/" /etc/postgresql/9.3/main/postgresql.conf
mv /var/lib/postgresql/9.3 /vol/postgresql/
chown -R postgres:postgres /vol/postgresql
/etc/init.d/postgresql start

sudo -u postgres psql -c "CREATE ROLE census WITH NOSUPERUSER LOGIN UNENCRYPTED PASSWORD 'censuspassword';"
sudo -u postgres psql -c "CREATE DATABASE census WITH OWNER census;"

# Make login passwordless
echo "localhost:5432:census:census:censuspassword" > /home/ubuntu/.pgpass
chmod 0600 /home/ubuntu/.pgpass
