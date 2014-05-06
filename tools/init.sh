#!/bin/bash
# By Rupert
# Install script for initializing mytravel-asia development, setup directories etc. 
# This script should run on development or test environment only

# Grant User Privileges base on database.yml
echo "Granting privileges for mta and rupert"
mysql -uroot -p -D mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'mta'@'%' identified by 'mta' WITH GRANT OPTION;"
mysql -uroot -p -D mysql -e "GRANT ALL PRIVILEGES ON *.* TO 'rupert'@'%' identified by '' WITH GRANT OPTION;"

# Create Initial SPHINX directories
# Get base directory, it should be mytravelasia-rails
echo "Create Initial SPHINX directories"
mkdir -p tmp/sphinx/development
mkdir -p tmp/sphinx/test
