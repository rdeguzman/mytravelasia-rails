# encoding: utf-8
require 'csv'
require "#{Rails.root}/lib/tasks/database_backup"

raw_config = YAML.load_file("#{Rails.root}/hotel_data/data_config.yml")["hotel_data"]
DATA_CONFIG = raw_config["agoda"].to_options! unless raw_config.nil?
DATA_MATCH = raw_config["data_match"].to_options! unless raw_config.nil?

namespace :agoda do

  namespace :seed do
    task :destroy => [:environment] do
      Agoda.destroy_all
    end

    task :main0 => [:environment] do
      csv_file = "#{DATA_CONFIG[:main]}.csv"
      csv_path = "#{Rails.root}/hotel_data/#{DATA_CONFIG[:source_path]}/#{csv_file}"

      puts "Using #{csv_path}"

      hotel_id = 0
      hotel_name = 1
      hotel_address_i = 2
      hotel_address_ii = 3
      country_id = 4
      country_name = 5
      city_id = 6
      city_name = 7
      area_id = 8
      area_name = 9
      hotel_description = 10
      star_rating = 11
      hotel_URL = 12
      number_of_reviews = 13
      user_rating_average = 14
      rate_from = 15

      count = total = 0

      CSV.foreach(csv_path) do |r|
        total += 1
      end

      CSV.foreach(csv_path) do |row|

        if not DATA_MATCH[:countries].include? row[country_name]
          next
        end

        begin
          puts "Processing #{count}/#{total}"

          current_agoda = Agoda.find_by_id(row[hotel_id])

          if current_agoda.blank?
            agoda = Agoda.new
            agoda.id = row[hotel_id]
            agoda.hotel_name = row[hotel_name]
            agoda.address = row[hotel_address_i]
            agoda.address_ii = row[hotel_address_ii]
            agoda.country_id = row[country_id]
            agoda.country_name = row[country_name]
            agoda.city_id = row[city_id]
            agoda.city_name = row[city_name]
            agoda.area_id = row[area_id]
            agoda.area_name = row[area_name]
            agoda.hotel_description = row[hotel_description]
            agoda.star_rating = row[star_rating]
            agoda.hotel_web_url = row[hotel_URL]
            agoda.number_of_reviews = row[number_of_reviews]
            agoda.user_rating_average = row[user_rating_average]
            agoda.rate_from = row[rate_from]

            agoda.hotel_mobile_url = agoda.hotel_url

            agoda.save!

            count += 1
          else
            puts "Agoda Hotel Id: #{row[hotel_id]} already exists."
          end
        rescue
          puts "Agoda Hotel Id: #{row[hotel_id]} was not inserted."
        end
      end

      puts "Inserted #{count} agoda hotels"
    end

    task :main1 => [:environment] do
      count = 0
      raw_agodas = RawAgoda.where(:countryisocode => "KR")
      total = raw_agodas.count

      puts "#{total} records"

      raw_agodas.each do |row|

        current_agoda = Agoda.find_by_id(row.id)

        if current_agoda.blank?
          puts "Inserted id: #{row.id}"

          agoda = Agoda.new
          agoda.id = row.id
          agoda.hotel_name = row.hotel_name
          agoda.hotel_translated_name = row.hotel_translated_name
          agoda.address = row.addressline1
          agoda.address_ii = row.addressline2
          agoda.country_id = row.country_id
          agoda.country_name = row.country
          agoda.city_id = row.city_id
          agoda.city_name = row.city
          agoda.zip_code = row.zipcode
          agoda.hotel_description = row.overview
          agoda.star_rating = row.star_rating
          agoda.hotel_web_url = "http://www.agoda.com#{row.url}"
          agoda.number_of_reviews = row.number_of_reviews
          agoda.user_rating_average = row.rating_average
          agoda.rate_from = row.rates_from_usd

          agoda.latitude = row.latitude
          agoda.longitude = row.longitude

          image_list = []
          if row.photo1.length > 0
            image_list.push(row.photo1)
          end
          if row.photo2.length > 0
            image_list.push(row.photo2)
          end
          if row.photo3.length > 0
            image_list.push(row.photo3)
          end
          if row.photo4.length > 0
            image_list.push(row.photo4)
          end
          if row.photo5.length > 0
            image_list.push(row.photo5)
          end

          if image_list.size > 0
            agoda.images = image_list.join("|")
          end

          agoda.hotel_mobile_url = agoda.hotel_web_url
          agoda.full_address = agoda.full_address_cleaned
          agoda.save!

          count += 1

          puts "Inserted #{count}/#{total} id: #{row.id}"
        else
          puts "Agoda Hotel Id: #{row.id} already exists."
        end
      end

      puts "Inserted #{raw_agodas.count} agoda hotels"
    end

    task :location => [:environment] do
      csv_file = "#{DATA_CONFIG[:location]}.csv"
      csv_path = "#{Rails.root}/hotel_data/#{DATA_CONFIG[:source_path]}/#{csv_file}"

      puts "Using #{csv_path}"

      hotel_id = 0
      hotel_name = 2
      hotel_address = 3
      latitude = 10
      longitude = 11
      phone_number = 8
      fax_number = 9

      count = 0

      CSV.foreach(csv_path) do |row|
        begin
          agoda = Agoda.find_by_id(row[hotel_id])

          unless agoda.blank?
            agoda.latitude = row[latitude]
            agoda.longitude = row[longitude]
            agoda.phone_number = row[phone_number]
            agoda.fax_number = row[fax_number]

            agoda.save

            count += 1
          end
        rescue Exception => e
          puts e.message
        end
      end

      puts "Updated #{count} hotel with locations"
    end

    task :update_full_address => [:environment] do
      count = 0

      hotels = Agoda.recently_added
      total = hotels.count

      hotels.each do |hotel|
        hotel.full_address = hotel.full_address_cleaned
        hotel.save

        count += 1
        puts "#{count}/#{total} #{hotel.full_address_cleaned}"
      end

      puts "Updated #{count} hotels"
    end

    task :update_images => [:environment] do
      current_agodas = Agoda.where("images is null")
      total = current_agodas.count
      puts "Total: #{total}"

      i = 0
      current_agodas.each do |current|
        i = i + 1

        row = RawAgoda.find_by_id(current.id)

        if row
          image_list = []
          if row.photo1.length > 0
            image_list.push(row.photo1)
          end
          if row.photo2.length > 0
            image_list.push(row.photo2)
          end
          if row.photo3.length > 0
            image_list.push(row.photo3)
          end
          if row.photo4.length > 0
            image_list.push(row.photo4)
          end
          if row.photo5.length > 0
            image_list.push(row.photo5)
          end

          if image_list.size > 0
            current.images = image_list.join("|")
            current.save
          end

          puts "#{i}/#{total} #{current.hotel_name} (#{image_list.size})"
        else
          puts "#{i}/#{total} #{current.hotel_name} NoMatch (0)"
        end

      end
    end

  end

  task :backup => [:environment] do
    database_backup("agodas")
  end

  task :update => [:environment] do
    count = 0

    agodas = Agoda.no_location.no_ratings.no_rate.recently_added

    if agodas.empty?
      agodas = Agoda.recently_added
    end

    puts "Processing #{agodas.count}"

    agodas.each do |hotel|

      if hotel.page_exists? hotel.hotel_web_url
        hotel.current_status = "valid"
        hotel.save
      else
        if hotel.error_code == "not_found"
          hotel.current_status = "not_found"
          hotel.save
        end
      end

      puts "id:#{hotel.id}  error_code:#{hotel.error_code} url:#{hotel.hotel_web_url}"
      sleep 3

      count += 1
    end

    puts "Updated #{count} hotels"
  end

  task :remove_duplicates => [:environment] do
    require 'fuzzystringmatch'
    include FuzzyStringMatch

    processing_count = 0
    duplicate_count = 0

    source_hotels = Agoda.valid_only

    puts "Found #{source_hotels.count}"

    jarow = JaroWinkler.create( :native )

    source_hotels.each do |source_hotel|

      if not source_hotel.is_valid?
        break
      end

      flag_unique = true

      #Get all valid target hotels which does not have the id of the source_hotel
      target_hotels = Agoda.valid_only.where("id != ?", source_hotel.id).where(:country_id => source_hotel.country_id)

      target_hotels.each do |target_hotel|

        weight_name = jarow.getDistance(source_hotel.hotel_name, target_hotel.hotel_name)
        weight_address = jarow.getDistance(source_hotel.full_address, target_hotel.full_address)

        if weight_name >= DATA_MATCH[:duplicate_name_threshold] and weight_address > DATA_MATCH[:duplicate_address_threshold]
          flag_unique = false

          puts "-------------------------------------"
          puts source_hotel.print_description
          source_hotel.target_description
          puts "weight_name: #{weight_name}"
          puts "weight_address: #{weight_address}"
          puts "------------------------------------"

          source_hotel.weight = target_hotel.weight = 0

          if source_hotel.number_of_reviews > target_hotel.number_of_reviews then
            source_hotel.add_weight(0.25)
          else
            target_hotel.add_weight(0.25)
          end

          if source_hotel.user_rating_average > target_hotel.user_rating_average then
            source_hotel.add_weight(0.10)
          else
            target_hotel.add_weight(0.10)
          end

          if source_hotel.has_location?
            source_hotel.add_weight(0.25)
          end

          if target_hotel.has_location?
            target_hotel.add_weight(0.25)
          end

          unless source_hotel.rate_from.blank?
            source_hotel.add_weight(0.10)
          end

          unless target_hotel.rate_from.blank?
            target_hotel.add_weight(0.10)
          end

          if source_hotel.weight > target_hotel.weight
            target_hotel.current_status = "duplicate"
            target_hotel.notes ="Duplicate with #{source_hotel.id}"
            target_hotel.save

            source_hotel.current_status = "valid_unique"
            source_hotel.save
          else
            source_hotel.current_status = "duplicate"
            source_hotel.notes ="Duplicate with #{source_hotel.id}"
            source_hotel.save

            target_hotel.current_status = "valid_unique"
            target_hotel.save

          end

          duplicate_count += 1
        end
      end

      if flag_unique
        source_hotel.current_status = "valid_unique"
        source_hotel.save
      end

      processing_count += 1
      puts "Processing #{source_hotels.count}"
    end

    puts "Found #{duplicate_count} duplicates in #{processing_count}"
  end

  def get_poi_id(obj, which_id)
    poi_id = nil
    match = HotelMatch.where(obj)

    unless match.empty?
      poi_id = match.first[which_id.to_sym]
    end

    return poi_id
  end

  task :match_link => [:environment] do
    count = processing_count = 0

    agodas = Agoda.currently_valid
    agodas.each do |source_hotel|
      puts "Processing #{processing_count}"

      obj = {:source_id => source_hotel.id,
             :source_model => source_hotel.class.to_s,
             :match_model => "Poi"}

      poi_id = get_poi_id(obj, "match_id")

      if poi_id.nil?
        obj = {:match_id => source_hotel.id,
               :match_model => source_hotel.class.to_s,
               :source_model => "Poi"}
        poi_id = get_poi_id(obj, "source_id")
      end

      if not poi_id.nil?
        source_hotel.poi_id = poi_id
        source_hotel.save

        count += 1
      end

      processing_count += 1
    end

    puts "Updated #{count}"

  end

  task :clean_countries => [:environment] do
    count = 0

    Agoda.all.each do |hotel|
      if not DATA_MATCH[:countries].include? hotel.country_name
        count += 1
        puts "#{hotel.country_name}"
        hotel.destroy
      end
    end

    puts "#{count}"
  end

  task :create_poi => [:environment] do
    count = 0
    hotels = Agoda.recently_added.where(:country_name => "India").where("city_name <> ''")
    total = hotels.count

    hotels.each do |hotel|
      puts "Processing #{count}/#{total} #{hotel.id} #{hotel.hotel_name}"
      hotel.create_poi
      count = count + 1
    end
  end

end
