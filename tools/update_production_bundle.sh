#!/bin/sh
APP_ROOT=/srv/rails/mytravel-asia

echo "Preparing to remove items prior to running bundle..."
cd $APP_ROOT/current
rm -Rf $APP_ROOT/current/.bundle
rm -Rf $APP_ROOT/current/Gemfile.lock
rm -Rf $APP_ROOT/current/vendor

echo "Running bundle..."
export RAILS_ENV=production
bundle install -V --without development:test
bundle install -V --without development:test --deployment

echo "If Bundle seems to be successful then continue. Continue (y/n)?"

read answer
if [ $answer = 'y' ]
then
   echo "Ok let's go"

   rm -rf $APP_ROOT/current/.bundle

   mv $APP_ROOT/shared/vendor $APP_ROOT/shared/vendor.old
   mv $APP_ROOT/shared/Gemfile.lock $APP_ROOT/shared/Gemfile.lock.old

   mv $APP_ROOT/current/vendor $APP_ROOT/shared/
   mv $APP_ROOT/current/Gemfile.lock $APP_ROOT/shared/

   ln -s $APP_ROOT/shared/vendor $APP_ROOT/current/vendor
   ln -s $APP_ROOT/shared/.bundle $APP_ROOT/current/.bundle
   ln -s $APP_ROOT/shared/Gemfile.lock $APP_ROOT/current/Gemfile.lock

   #rm $APP_ROOT/current/config/database.yml
   #ln -s $APP_ROOT/shared/database.yml $APP_ROOT/current/config/database.yml

else
   echo "Not continuing. Reverting to old"

   ln -s $APP_ROOT/shared/vendor $APP_ROOT/current/vendor
   ln -s $APP_ROOT/shared/.bundle $APP_ROOT/current/.bundle
   ln -s $APP_ROOT/shared/Gemfile.lock $APP_ROOT/current/Gemfile.lock

   exit
fi

echo "Please test from the browser if everything is fine. If ok, remove old vendor.old and Gemfile.lock.old (y/n)?"

read confirmation
if [ $confirmation = 'y' ]
then
   rm -rf $APP_ROOT/shared/vendor.old
   rm -rf $APP_ROOT/shared/Gemfile.lock.old
else
    exit
fi