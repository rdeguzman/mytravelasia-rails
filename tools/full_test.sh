#!/bin/sh
# Use this script in Rails.root. This script should be run if there are database migrations before cucumber tests

migrate_and_seed(){
  echo "Do you want to migrate and seed before running the tests? Continue(y/n)?"
  read answer
  if [ $answer = 'y' ]; then
    rake db:migrate
    rake db:seed
    echo "Migrate and Seed successful."
  fi
}

echo "Do you want to download and restore? Continue(y/n)?"
read answer
if [ $answer = 'y' ]; then
  sh tools/restore.sh
  rake db:migrate
  rake db:seed
else
  migrate_and_seed
fi

rake thinking_sphinx:rebuild
bundle exec guard -g specs start
