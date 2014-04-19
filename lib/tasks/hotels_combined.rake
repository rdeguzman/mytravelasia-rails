require 'csv'
require "#{Rails.root}/lib/tasks/database_backup"

raw_config = YAML.load_file("#{Rails.root}/hotel_data/data_config.yml")["hotel_data"]
DATA_CONFIG = raw_config["hotels_combined"].to_options! unless raw_config.nil?
DATA_MATCH = raw_config["data_match"].to_options! unless raw_config.nil?

namespace :hotels_combined do

  namespace :seed do
    task :destroy => [:environment] do
      HotelsCombined.destroy_all
    end

    task :main => [:environment] do
      csv_file = "#{DATA_CONFIG[:main]}.csv"
      csv_path = "#{Rails.root}/hotel_data/#{DATA_CONFIG[:source_path]}/#{csv_file}"

      puts "Using #{csv_path}"

      hotel_id = 0
      hotel_file_name = 1
      hotel_name = 2
      rating = 3
      city_id = 4
      city_file_name = 5
      city_name = 6
      state_id = 7
      state_file_name = 8
      state_name = 9
      country_code = 10
      country_file_name = 11
      country_name = 12
      image_id = 13
      address = 14
      min_rate = 15
      currency_code = 16
      latitude = 17
      longitude = 18
      number_of_reviews = 19
      consumer_rating = 20
      property_type = 21
      chain_id = 22
      facilities = 23

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

          current = HotelsCombined.find_by_id(row[hotel_id])

          if current.blank?
            hc = HotelsCombined.new
            hc.id = row[hotel_id]
            hc.hotel_file_name = row[hotel_file_name]
            hc.hotel_name = row[hotel_name]
            hc.rating = row[rating]
            hc.city_id = row[city_id]
            hc.city_file_name = row[city_file_name]
            hc.city_name = row[city_name]
            hc.state_id = row[state_id]
            hc.state_file_name = row[state_file_name]
            hc.state_name = row[state_name]
            hc.country_code = row[country_code]
            hc.country_file_name = row[country_file_name]
            hc.country_name = row[country_name]
            hc.image_id = row[image_id]
            hc.address = row[address]
            hc.min_rate = row[min_rate]
            hc.currency_code = row[currency_code]
            hc.latitude = row[latitude]
            hc.longitude = row[longitude]
            hc.number_of_reviews = row[number_of_reviews]
            hc.consumer_rating = row[consumer_rating]
            hc.property_type = row[property_type]
            hc.chain_id = row[chain_id]
            hc.facilities = row[facilities]

            hc.hotel_web_url = "http://www.hotelscombined.com/Hotel/#{hc.hotel_file_name}.htm"
            hc.hotel_mobile_url = "http://www.hotelscombined.com/Hotel/#{hc.hotel_file_name}.htm?Mobile=1"

            hc.full_address = hc.full_address_cleaned

            hc.save!

            count += 1
          end
        rescue
          puts "HC Hotel Id: #{row[hotel_id]} was not inserted."
        end
      end

      puts "Inserted #{count} hc hotels"
    end
  
    task :filenames => [:environment] do
      csv_file = "#{DATA_CONFIG[:filenames]}.csv"
      csv_path = "#{Rails.root}/hotel_data/#{DATA_CONFIG[:source_path]}/#{csv_file}"

      puts "Using #{csv_path}"

      hotel_id = 0
      folder_name = 12
      file_name = 13

      count = 0

      CSV.foreach(csv_path) do |row|
        begin
          hc = HotelsCombined.find_by_id(row[hotel_id])

          unless hc.blank?
            hc.folder = row[folder_name]
            hc.filename = row[file_name]

            hc.save

            count += 1
          end

        rescue
          puts "HC Hotel Id: #{row[hotel_id]} was not updated."
        end
      end

      puts "Updated #{count} hc hotels"

    end

    task :process_xml_files => [:environment] do
      hotels = HotelsCombined.all

      count = 0

      hotels.each do |hotel|
        unless hotel.filename.blank?
          xml_path = "#{DATA_CONFIG[:xml_path]}/#{hotel.folder}/#{hotel.filename}"

          if File.exists? xml_path

            f = File.open(xml_path)

            begin
              doc = Nokogiri::XML(f)

              save_flag = false

              #time_check_in = doc.xpath('//Checkin').text
              #time_check_out = doc.xpath('//Checkout').text

              description_nodes = doc.xpath("//Description//Value")
              if description_nodes.count > 0
                description_raw = description_nodes.collect {|d| d.text}.join("|")
                description = description_nodes.first.text

                hotel.hotel_description_raw = description_raw
                hotel.hotel_description = description
                save_flag = true
              end

              images = doc.xpath("//Images//Image")
              unless images.empty?
                image_list = images.collect {|i| i.text}.join(",")

                hotel.images = image_list
                save_flag = true
              end

              f.close

              if save_flag
                hotel.save
                puts "Saved #{xml_path} images:#{images.count} #{hotel.hotel_name}"
                count += 1
              end

            rescue
              puts "Unable to process #{xml_path} #{hotel.hotel_name}"
            end

          end

        end
      end

      puts "Processed #{count}"
    end

    task :update_urls => [:environment] do
      count = 0

      hotels = HotelsCombined.all
      hotels.each do |hotel|
        hotel.hotel_web_url = "http://www.hotelscombined.com/Hotel/#{hotel.hotel_file_name}.htm"
        hotel.hotel_mobile_url = "http://www.hotelscombined.com/Hotel/#{hotel.hotel_file_name}.htm?Mobile=1"
        hotel.save
        count += 1
      end

      puts "Updated #{count} hc hotels"
    end

    task :update_full_address => [:environment] do
      count = 0

      hotels = HotelsCombined.currently_valid
      total = hotels.count

      hotels.each do |hotel|
        hotel.full_address = hotel.full_address_cleaned
        hotel.save

        count += 1
        puts "#{count}/#{total} #{hotel.full_address_cleaned}"
      end

      puts "Updated #{count} hotels"
    end
  end

  task :backup => [:environment] do
    database_backup("hotels_combineds")
  end

  task :update => [:environment] do
    count = 0

    hotels = HotelsCombined.no_location.no_ratings.no_rate.recently_added

    if hotels.empty?
      hotels = HotelsCombined.recently_added
    end

    puts "Processing #{hotels.count}"

    hotels.each do |hotel|

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

    puts "Updated #{count} hc hotels"
  end

  task :remove_duplicates => [:environment] do
    require 'fuzzystringmatch'
    include FuzzyStringMatch

    processing_count = 0
    duplicate_count = 0

    source_hotels = HotelsCombined.valid_only

    puts "Found #{source_hotels.count}"

    jarow = JaroWinkler.create( :native )

    source_hotels.each do |source_hotel|

      if not source_hotel.is_valid?
        break
      end

      flag_unique = true

      #Get all valid target hotels which does not have the id of the source_hotel
      target_hotels = HotelsCombined.valid_only.where("id != ?", source_hotel.id).where(:country_name => source_hotel.country_name)

      target_hotels.each do |target_hotel|

        weight_name = jarow.getDistance(source_hotel.hotel_name, target_hotel.hotel_name)
        weight_address = jarow.getDistance(source_hotel.full_address, target_hotel.full_address)

        if weight_name >= DATA_MATCH[:duplicate_name_threshold] and weight_address > DATA_MATCH[:duplicate_address_threshold]
          flag_unique = false

          puts "#{source_hotel.hotel_name} (#{source_hotel.number_of_reviews})"
          puts "#{target_hotel.hotel_name} (#{target_hotel.number_of_reviews})"
          puts "#{source_hotel.hotel_web_url}"
          puts "long/lat:#{source_hotel.latitude} #{source_hotel.longitude}"

          puts "#{source_hotel.full_address}"
          puts "#{target_hotel.full_address}"
          puts "#{target_hotel.hotel_web_url}"
          puts "long/lat:#{target_hotel.latitude} #{target_hotel.longitude}"
          puts "weight_name: #{weight_name}"
          puts "weight_address: #{weight_address}"
          puts "------------------------------------"

          source_hotel.weight = target_hotel.weight = 0

          if source_hotel.number_of_reviews > target_hotel.number_of_reviews then
            source_hotel.add_weight(0.25)
          else
            target_hotel.add_weight(0.25)
          end

          if source_hotel.consumer_rating > target_hotel.consumer_rating then
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

          if source_hotel.min_rate > 0
            source_hotel.add_weight(0.10)
          end

          if target_hotel.min_rate > 0
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

    source_hotels = HotelsCombined.currently_valid
    source_hotels.each do |source_hotel|
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

    HotelsCombined.all.each do |hotel|
      if not DATA_MATCH[:countries].include? hotel.country_name
        count += 1
        puts "#{hotel.country_name}"
        hotel.destroy
      end
    end

    puts "#{count}"
  end

end
