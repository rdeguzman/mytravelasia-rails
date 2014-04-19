namespace :partner_hotel do
  task :backup => [:environment] do
    database_backup("partner_hotels")
  end

  task :destroy => [:environment] do
    PartnerHotel.destroy_all
  end

  task :seed => [:environment] do
    include PartnerHotelUtil

    count = 1
    update_count = 1

    #pois = Poi.hotel#.where(:id => 110349)

    pois = Poi.hotel.where(:country_name => "Sri Lanka")

    pois.each do |poi|
      puts "Processing #{count}/#{pois.count} #{poi.id} #{poi.name} #{poi.full_address}"

      poi_id = poi.id

      datasets_all = DATA_MATCH[:dataset].split(",")
      datasets = datasets_all - ["Poi"]

      datasets.each do |dataset|
        target_hotel = dataset.constantize.find_by_poi_id(poi.id)

        unless target_hotel.blank?

          if PartnerHotelUtil.create_safely(target_hotel, poi)
            update_count += 1
          end

        end
      end

      count += 1

    end

    puts "Processed #{count} partner hotels. Updated #{update_count}"

  end

  namespace :update do
    task :urls => [:environment] do
      count = 1

      partner_hotels = PartnerHotel.all
      total = partner_hotels.count

      partner_hotels.each do |partner_hotel|
        puts "#{count}/#{total}"

        source_hotel = partner_hotel.partner_type.constantize.find(partner_hotel.hotel_id)
        partner_hotel.web_partner_url = source_hotel.web_partner_url
        partner_hotel.mobile_partner_url = source_hotel.mobile_partner_url
        partner_hotel.save

        count += 1
      end

      puts "Processed #{count} partner_hotels"
    end
    task :poi_ids => [:environment] do
      count = 1

      partner_hotels = PartnerHotel.all
      total = partner_hotels.count

      partner_hotels.each do |partner_hotel|
        puts "#{count}/#{total}"

        partner_hotel.update_source

        #source_hotel = partner_hotel.partner_type.constantize.find(partner_hotel.hotel_id)
        #source_hotel.poi_id = partner_hotel.poi_id
        #source_hotel.current_status = "valid_manual"
        #source_hotel.save

        count += 1
      end

      puts "Processed #{count} partner_hotels"
    end

    #rake partner_hotel:update:rooms provider="Agoda" poi_id="107154" country_name="Philippines" --trace
    desc "Fetches room rates from provider"
    task :rooms => [:environment] do
      process_start = Time.now

      room_current_count = 1
      room_not_available_count = 0
      room_updated_count = 0

      day = 60 * 60 * 24
      yesterday_date = Time.now - (day * 7)
      start_date = Time.now + (day * APP_CONFIG[:fetch_rooms_check_in_date_from_now])
      end_date = start_date + (day * 1)

      country_name = ENV["country_name"]
      provider = ENV["provider"]

      #Anantara Lawana Resort And Spa Koh Samui, Thailand
      if ENV["poi_id"]
        pois = Poi.hotel.where(:id => "#{ENV['poi_id']}")
      else
        sql =  "SELECT DISTINCT p.*
                FROM pois p, partner_hotels h
                WHERE poi_type_name = 'Hotel'
                AND p.id = h.poi_id
                AND h.partner_type = '#{provider}'
                AND p.country_name = '#{country_name}'
                AND p.updated_at < '#{yesterday_date}'
                ORDER BY total_views DESC"
        puts sql
        pois = Poi.find_by_sql(sql)
      end

      pois_count = 1
      pois_total = pois.count
      puts "Total Pois: #{pois_total}"

      crawler = WebCrawler.new(:javascript => true)

      pois.each do |poi|
        puts "#{pois_count}/#{pois_total} ----- POI:#{poi.id} #{poi.name} ----- NR: #{room_not_available_count} RU: #{room_updated_count} TS: #{Time.now} ------"

        partner_hotels = poi.partner_hotels.where("partner_type = '#{provider}'")

        partner_hotels.each do |partner_hotel|
          source_hotel = partner_hotel.partner_type.constantize.find(partner_hotel.hotel_id)

          t_current_start = Time.now

          rooms = source_hotel.fetch_rooms(start_date.strftime("%Y-%m-%d"), end_date.strftime("%Y-%m-%d"), crawler)

          if rooms.empty?
            t_current_end = Time.now
            t_elapsed = t_current_end - t_current_start

            room_not_available_count = room_not_available_count + 1

            puts "  #{room_current_count} #{partner_hotel.partner_type}: No available room. Time:#{t_elapsed}"
          else
            remote_partner = RemotePartnerHotel.new
            response = remote_partner.post(partner_hotel.id, rooms)

            t_current_end = Time.now
            t_elapsed = t_current_end - t_current_start

            room_updated_count = room_updated_count + 1

            puts "  #{room_current_count} #{partner_hotel.partner_type}: #{rooms.count} Rooms Updated. #{partner_hotel.currency_min_rate} Time:#{t_elapsed}"
          end

          room_current_count = room_current_count + 1
        end

        poi.touch

        pois_count = pois_count + 1

      end

      crawler.close

      process_end = Time.now
      process_elapsed = process_end - process_start
      puts "Total Elapsed: #{process_elapsed} seconds"
    end

  end

end