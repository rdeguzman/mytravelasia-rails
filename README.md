## Installation
  
### OSX
	
	% brew install mysql
	% brew install sphinx --mysql  
	
  
## Let's get ready

  READ tools/init.sh
  
  	% tools/init.sh  

  **What does the script do?**

  It creates "mta" user for mysql. 
  
  	GRANT ALL PRIVILEGES ON *.* TO 'mta'@'%' identified by 'mta' WITH GRANT OPTION;
  
  We also create a "rupert" user because some view was created by rupert.

	GRANT ALL PRIVILEGES ON *.* TO 'rupert'@'%' identified by '' WITH GRANT OPTION;
	
  Create SPHINX directories	
	
  
## Seeding the Database

  We can use "mta" in our database.yml for development and test environment    
	development:
	  adapter: mysql2
	  encoding: utf8
	  reconnect: false
	  database: tsa_development
	  pool: 5
	  username: mta
	  password: mta
	  socket: /tmp/mysql.sock
	  
  Note to change this in production ofcourse!

  Runnig tools/restore.sh gives us the option to download a gzip sql OR use an existing SQL dump
	
	% tools/restore.sh
	How do you want to seed the database?
	1. Download from remote
	2. Dump production from localhost
	3. Use existing /Projects/rails/mytravelasia-rails/tmp/backups/tsa_production.sql

## Testing
To test using rspec2 and cucumber simply run

    export RAILS_ENV=test
    rake db:clone #Note that we are populating test data from development using rake db:clone
    b guard -g specs start #b is an alias for bundle exec

## Indexing using Sphinx

Thinking Sphinx can be started and reindex using:

	rake ts:index or rake ts:reindex
  	rake ts:start

### Cronjob

This is in one line

	PATH=/sbin:/bin:/usr/sbin:/usr/bin
	30 * * * *  /home/rupert/bin/rvm-shell 'ruby-1.9.2-p180@travelspotsinasia' -c 'RAILS_ENV=production rake -f /srv/rails/mytravel-asia/current/Rakefile thinking_sphinx:rebuild' > $HOME/mytravel-asia.index.log

## Deployment

Deployment is run thru a capistrano recipe by user *rupert*. See deploy.rb for more details.

### Deploying for the first time

Do not include Gemfile.lock in git repo.

	You are trying to install in deployment mode after changing your Gemfile. 
	Run `bundle install` elsewhere and add the updated Gemfile.lock to version control.
	
If this is a development machine, remove the Gemfile freeze by running 

	`bundle install --no-deployment`.
	
Only if the application and directories is not yet setup in 
	
	cd /srv/rails/mytravel-asia/
	
You need cap to setup the appropriate directories
	
	cap deploy:setup

### Deploying normally without any gem changes

To deploy normally

	export DEPLOY=PRODUCTION
	cap deploy
	
This will do the ff:	

1. If you add or updated a gem, bundle installs this automatically for you
2. Creates a symbolic link for "tsa" images directory
3. Creates a symbolic link for the "database.yml" directory.
4. Restarts the apache2 passenger

### Email Support
Users support@mytravel-asia.com email address. Email service hosted by google, to login go to
https://www.google.com/a/cpanel/2rmobile.com/Dashboard

DNS redirected to Google. See
http://domains.yahoo.com/adns?d=mytravel-asia.com

## Hotel Resources

### General Partner Processing Procedure

	rake match:create
	rake partner_hotel:destroy #optional, be very careful
	rake partner_hotel:seed  #175.09s user 14.17s system 4% cpu 1:17:13.30 total
	rake destination:count

### HotelsCombined.com

Download these files:

	http://downloads.hotelscombined.com/StandardFeed/AllHotelsCsv.zip (Standard Data Feeds > Single File > Hotels_All.csv)
  hotelId,hotelFileName,hotelName,rating,cityId,cityFileName,cityName,stateId,stateFileName,stateName,countryCode,countryFileName,countryName,imageId,address,minRate,currencyCode,Latitude,Longitude,NumberOfReviews,ConsumerRating,PropertyType,ChainID,Facilities

  http://downloads.hotelscombined.com/IndexFiles/HotelListCSV.zip (Index File)
  HotelID,HotelFileName,HotelName,CityID,CityFileName,CityName,CountryCode,CountryFileName,CountryName,StateID,StateFileName,StateName,FolderName,FileName

  http://downloads.hotelscombined.com/HotelDatabase_EN.zip (zipped xml files)
  This contain a lot of files. Extract this to the desktop and update xml_path in data_config.yml

To run:

	rake hotels_combined:seed:main
	rake hotels_combined:seed:filenames
	rake hotels_combined:process_xml_files
	rake hotels_combined:remove_duplicates
	rake hotels_combined:update

### Agoda.com

Sample Link to Fetch the Rates

	http://ajaxsearch.partners.agoda.com/pages/agoda/default/waitpage.aspx?waitpage=hotel&fromInternal=1&cid=12345&countryID=70&cityID=16429&HotelID=240067&CheckIn=7/18/2012&CheckOut=7/21/2012&Rooms=1&Adults=2&Children=0&currency=USD

### Bookings.com

Known as PricelineBooking.


## Fetching Rooms

In app_config.yml in development 

	room_api: "http://www.mytravel-asia.com"

### Run rake task manually

We need to pass the **provider** and the **country_name**
	
	rake partner_hotel:update:rooms provider="Agoda" poi_id="107154" country_name="Philippines" --trace
	
### Jenkins job

Jenkins is setup locally on Mac. Sample job configuration

	#/bin/bash
	source /Users/rupert/.rvm/scripts/rvm
	export RAILS_ENV=development
	cd /Users/rupert/Desktop/mytaweb
	rvm use ruby-1.9.2-p180@mytravel-asia-dev
	rake partner_hotel:update:rooms provider="Agoda" country_name="Philippines" --trace