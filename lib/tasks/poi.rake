require "#{Rails.root}/lib/tasks/database_backup"

namespace :poi do
  task :backup => [:environment] do
    database_backup("pois")
  end

  task :update_full_address => [:environment] do
    count = 0

    #pois = Poi.where("full_address is null")
    #pois = Poi.where(:id => 141485)
    pois = Poi.where(:country_name => "China").where(:poi_type_name => ["Attraction","Restauarant","Night Life"])

    total = pois.count

    pois.each do |poi|

      if not poi.address.include? "#{poi.destination_name}"
        #poi.full_address = "#{poi.address}, #{poi.destination_name}"
        poi.full_address = "#{poi.address}, #{poi.destination_name}, China"
      else
        poi.full_address = poi.address
      end

      poi.save
      count += 1

      puts "#{count}/#{total}"
    end

    puts "Updated #{count} pois"
  end

  task :update_picture_count => [:environment] do
    count = 0

    Poi.before_save.clear
    pois = Poi.all#.where(:id => 129168)
    total = pois.count

    pois.each do |poi|
      puts "Processing #{count}/#{total}"
      poi.update_picture_count
      poi.save
      puts "#{poi.id} #{poi.name} total_pictures: #{poi.total_pictures}"
      count += 1
    end
  end

  task :update_description_for_hotels => [:environment] do
    count = 0

    pois = Poi.find_by_sql"SELECT * FROM pois WHERE description is null or description = '' AND poi_type_name = 'Hotel'"
    total = pois.count

    pois.each do |poi|
      puts "Processing #{count}/#{total} #{poi.id} #{poi.name}"

      partner_hotels = PartnerHotel.where(:poi_id => poi.id, :partner_type => "HotelsCombined")

      if not partner_hotels.empty?
        partner_hotel = partner_hotels.first

        if not partner_hotel.description.blank? and not partner_hotel.description.length == 0
          poi.description = partner_hotel.description
          poi.save

          puts "Updated description."
        end
      end

      count += 1
    end

    puts "Updated #{count}"

  end

  task :update_duplicate_hotels1 => [:environment] do
    duplicate_dataset = Poi.find_by_sql('SELECT name, country_name, address, description, count(*) as total
    FROM pois
    WHERE poi_type_name = "Hotel"
    AND country_name = "Philippines"
    GROUP BY name, country_name
    HAVING total >= 2
    ORDER BY total DESC')

    duplicate_dataset.each do |dataset|
      puts "----------"
      #puts "#{dataset.name} #{dataset.total}"

      poi_keep = nil
      poi_destroy = nil

      description = ""
      full_address = ""

      web_url = ""
      email = ""
      tel_no = ""

      pois = Poi.where(:name => dataset.name, :country_name => dataset.country_name)

      pois.each do |poi|
        partner_hotels = PartnerHotel.where(:poi_id => poi.id)
        partner_hotel = PartnerHotel.find_by_poi_id(poi.id)

        puts "#{poi.id} #{poi.name} #{poi.full_address} count:#{partner_hotels.count} desc: #{poi.description.empty?} partner_type:#{partner_hotel.partner_type if not partner_hotel.blank?} total_views: #{poi.total_views}"

        if not poi.description.blank?
          if poi.description.length > description.length
            description = poi.description
          end
        end

        if not poi.full_address.blank?
          if poi.full_address.length > full_address.length
            full_address = poi.full_address
          end
        end

        if not poi.web_url.blank?
          if poi.web_url.length > web_url.length
            web_url = poi.web_url
          end
        end

        if not poi.email.blank?
          if poi.email.length > email.length
            email = poi.email
          end
        end

        if not poi.tel_no.blank?
          if poi.tel_no.length > tel_no.length
            tel_no = poi.tel_no
          end
        end

        if partner_hotels.count > 0
          poi_keep = poi
        else
          poi_destroy = poi
        end
      end

      #if !poi_destroy.nil?
      #  puts "Destroying #{poi_destroy.id} #{poi_destroy.name} #{poi_destroy.full_address}"
      #  poi_destroy.destroy
      #end
      #
      #if !poi_keep.nil?
      #  puts "Saving #{poi_keep.id} #{poi_keep.name} #{poi_keep.full_address}"
      #  poi_keep.description = description
      #  poi_keep.full_address = full_address
      #  poi_keep.web_url = web_url
      #  poi_keep.tel_no = tel_no
      #  poi_keep.email = email
      #  poi_keep.save
      #end

    end

  end

  desc "Update duplicate pois/hotels with the same name and have agoda and hotels_combined"
  task :update_duplicate_hotels => [:environment] do
    duplicate_dataset = Poi.find_by_sql('SELECT name, country_name, address, description, count(*) as total
    FROM pois
    WHERE poi_type_name = "Hotel"
    GROUP BY name, country_name
    HAVING total >= 2
    ORDER BY total DESC')

    duplicate_dataset.each do |dataset|
      puts "----------"
      #puts "#{dataset.name} #{dataset.total}"

      poi_keep = nil
      poi_destroy = nil
      partner_hotel_to_update = nil

      pois = Poi.where(:name => dataset.name, :country_name => dataset.country_name)

      if pois.count == 2
        pois.each do |poi|
          partner_hotels = PartnerHotel.where(:poi_id => poi.id)
          partner_hotel = PartnerHotel.find_by_poi_id(poi.id)

          if partner_hotels.count == 1
            puts "#{poi.id} #{poi.name} #{poi.full_address} count:#{partner_hotels.count} desc: #{poi.description.empty?} partner_type:#{partner_hotel.partner_type if not partner_hotel.blank?} total_views: #{poi.total_views}"

            if partner_hotel.partner_type == "Agoda"
              poi_destroy = poi
              partner_hotel_to_update = partner_hotel
            elsif partner_hotel.partner_type == "HotelsCombined"
              poi_keep = poi
            end

          end

        end

      end

      if !partner_hotel_to_update.nil? and !poi_keep.nil?
        partner_hotel_to_update.poi_id = poi_keep.id
        partner_hotel_to_update.save

        source_hotel = partner_hotel_to_update.partner_type.constantize.find(partner_hotel_to_update.hotel_id)
        source_hotel.poi_id = poi_keep.id
        source_hotel.save

        puts "Updating partner_hotel #{partner_hotel_to_update.id} #{partner_hotel_to_update.partner_type} #{partner_hotel_to_update.poi_id}"
      end

      if !poi_destroy.nil? and !poi_keep.nil?
        puts "Destroying #{poi_destroy.id} #{poi_destroy.name} #{poi_destroy.full_address}"
        poi_destroy.destroy
      end

    end

  end

  task :update_partner_count => [:environment] do
    class SourceDB < ActiveRecord::Base; end
    PoiDuplicate = Class.new(SourceDB)
    PoiDuplicate.table_name = "pois_duplicates"

    pois = PoiDuplicate.all
    pois.each do |poi|
      partner_hotels = PartnerHotel.where(:poi_id => poi.id)

      poi.partner_count = partner_hotels.count
      poi.partners = partner_hotels.map {|ph| ph.partner_type}.join(", ").strip
      puts "#{poi.id} #{poi.partner_count} #{poi.partners}"
      poi.save
    end
  end

  task :update_partner_hotels_and_delete => [:environment] do
    class SourceDB < ActiveRecord::Base; end
    PoiDuplicate = Class.new(SourceDB)
    PoiDuplicate.table_name = "pois_duplicates"

    poi_duplicates = PoiDuplicate.find_by_sql("SELECT name, count(*) as total
    FROM pois_duplicates
    GROUP BY name
    HAVING total > 1
    ORDER BY name")
    puts "Duplicates found: #{poi_duplicates.count}"

    poi_duplicates.each do |dataset|
      poi_duplicates = PoiDuplicate.where(:name => dataset.name)

      final_partner_hotels = []

      poi_duplicates.each do |poi_dupe|

        partner_hotels = PartnerHotel.where(:poi_id => poi_dupe.id)

        partner_hotels.each do |ph|
          final_partner_hotels.push(ph)
        end
      end

      puts "#{dataset.name} c:#{final_partner_hotels.count} a:#{final_partner_hotels.map{|ph| ph.partner_type}.join(',')}"
    end
  end

  task :merge_partner_hotels => [:environment] do
    poi_names = Poi.where(:current_status => "duplicate")
    query_names = poi_names.map {|p| p.name}
    puts query_names

    query_names.each do |name|
      pois = Poi.where(current_status: "duplicate", name: "#{name}")

      final_poi = PoiUtil.merge_by_picture(pois)

      pois.each do |poi|
        partner_hotels = []

        PartnerHotel.where(poi_id: poi.id).each do |partner|
          partner_hotels.push(partner)
        end

        if final_poi != poi
          puts "#{poi.id} #{poi.name} #{partner_hotels.count} destroying"
          poi.destroy
        elsif final_poi == poi
          puts "#{poi.id} #{poi.name} #{partner_hotels.count} retain"
        end

        partner_hotels.each do |partner_hotel|
          partner_hotel.poi_id = final_poi.id
          partner_hotel.save

          base_hotel = partner_hotel.partner_type.constantize.find(partner_hotel.hotel_id)
          puts "#{base_hotel.class.to_s} #{base_hotel.id} #{base_hotel.hotel_name} #{base_hotel.poi_id} > #{final_poi.id}"

          base_hotel.poi_id = final_poi.id
          base_hotel.save
        end

      end
    end
  end

  task :booking_providers => [:environment] do
    pois = Poi.where(:bookable => true)
    pois.each do |poi|
      poi.booking_email_providers = "info@creontravel.com,s_h_e05@yahoo.com"
      poi.save
    end
  end

end