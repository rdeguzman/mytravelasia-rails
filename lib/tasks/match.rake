require "#{Rails.root}/lib/tasks/create_match"

namespace :match do
  task :backup => [:environment] do
    database_backup("hotel_matches")
  end

  #seed from existing matches found in partner_hotels
  task :seed => :environment do
    invalid_count = count = 0

    current_hotels = PartnerHotel.has_poi

    current_hotels.each do |hotel|
      hotel_id = hotel.hotel_id
      partner_type = hotel.partner_type

      if hotel.partner_type == "hotelscombined"
        target_hotel = HotelsCombined.find_by_id(hotel.hotel_id)
      elsif hotel.partner_type == "agoda"
        target_hotel = Agoda.find_by_id(hotel.hotel_id)
      end

      poi = Poi.find_by_id(hotel.poi_id)

      if not target_hotel.blank? and not poi.blank?
        puts "Match #{poi.name} #{target_hotel.hotel_name}"

        if target_hotel.is_valid?

          m = HotelMatch.new
          m.source_id = poi.id
          m.source_model = "Poi"
          m.match_id = target_hotel.id
          m.match_model = target_hotel.class.to_s
          m.match_type = "seed"

          m.weight_name = 1
          m.weight_address = 1
          m.weight_location = 1

          unless HotelMatch.exists?({:source_id => m.id, :source_model => "Poi",
                                    :match_id => m.match_id, :match_model => m.match_model})
            m.save
            target_hotel.current_status = "valid_matched"
            target_hotel.poi_id = m.id
            target_hotel.save
          end

          count += 1
        else
          hotel.destroy
          invalid_count += 1
        end

      end

    end

    puts "Added #{count} matches, invalid:#{invalid_count}"

  end

  task :find => [:environment] do
    count = {}
    count[:processing] = count[:exact] = count[:high] = count[:approximate] = count[:low] = count[:guess] = count[:wild_guess] = 0

    require 'fuzzystringmatch'
    include FuzzyStringMatch

    dataset_all = DATA_MATCH[:dataset].split(",")
    jarow = JaroWinkler.create( :native )

    ["PricelineBooking", "Agoda", "HotelsCombined"].each do |base_hotel|
      source_hotels = base_hotel.constantize.currently_valid.not_poi_matched
      total = source_hotels.count

      source_hotels.each do |source_hotel|

        puts "Processing #{count[:processing]}/#{total} #{base_hotel} id:#{source_hotel.id} #{source_hotel.name}"

        dataset_matched = HotelMatch.find_match_datasets(source_hotel.id, source_hotel.class.to_s)
        dataset_new = dataset_all - dataset_matched

        dataset_new.each do |dataset|

          ClassName = dataset.constantize
          target_hotels = ClassName.currently_valid

          target_hotels.each do |target_hotel|

            weight_name = jarow.getDistance(source_hotel.name, target_hotel.name)
            weight_address = jarow.getDistance(source_hotel.full_address, target_hotel.full_address)

            if weight_name >= DATA_MATCH[:exact_name_threshold] and weight_address >= DATA_MATCH[:exact_address_threshold]

              create_match(source_hotel, target_hotel, weight_name, weight_address, "exact")
              count[:exact] += 1

            elsif weight_name >= DATA_MATCH[:high_name_threshold] and weight_address >= DATA_MATCH[:high_address_threshold]

              create_match(source_hotel, target_hotel, weight_name, weight_address, "high")
              count[:high] += 1

            elsif weight_name >= DATA_MATCH[:high_name_threshold] and weight_address >= DATA_MATCH[:wild_guess_address_threshold]

              create_match(source_hotel, target_hotel, weight_name, weight_address, "high-name")
              count[:high] += 1

            elsif weight_name >= DATA_MATCH[:wild_guess_name_threshold] and weight_address >= DATA_MATCH[:high_address_threshold]

              create_match(source_hotel, target_hotel, weight_name, weight_address, "high-address")
              count[:high] += 1

            elsif weight_name >= DATA_MATCH[:approximate_name_threshold] and weight_address >= DATA_MATCH[:approximate_address_threshold]

              create_match(source_hotel, target_hotel, weight_name, weight_address, "approximate")
              count[:approximate] += 1

            elsif weight_name >= DATA_MATCH[:low_name_threshold] and weight_address >= DATA_MATCH[:low_address_threshold]

              create_match(source_hotel, target_hotel, weight_name, weight_address, "low")
              count[:low] += 1

            elsif weight_name >= DATA_MATCH[:guess_name_threshold] and weight_address >= DATA_MATCH[:guess_address_threshold]

              create_match(source_hotel, target_hotel, weight_name, weight_address, "guess")
              count[:guess] += 1
            end
          end
        end

        count[:processing] += 1

      end
    end

  end

  desc "Search for hotel matches and update source_hotel.poi_id. Does not create partner_hotel"
  task :create => [:environment] do
    include HotelMatchUtil

    count = {}
    count[:add] = count[:update_poi_id] = 0

    base_datasets = DATA_MATCH[:dataset].split(",") - ["Poi"]

    base_datasets.each do |base_dataset|
      source_hotels = base_dataset.constantize.currently_valid.not_poi_matched#.limit(1)
      total = source_hotels.count

      puts "Processing #{total}"

      source_hotels.each do |source_hotel|
        puts "-------------------------------"
        puts "Source: #{source_hotel.class.to_s}(#{source_hotel.id}):#{source_hotel.hotel_name}|#{source_hotel.full_address}"
        flag_insert = true

        datasets_all = DATA_MATCH[:dataset].split(",")
        datasets = datasets_all - ["#{source_hotel.class.to_s}"]

        datasets.each do |dataset|
          #Look for a match
          matches1 = HotelMatch.where(:source_id => source_hotel.id,
                                      :source_model => source_hotel.class.to_s,
                                      :match_model => dataset).order_by_weights

          matches2 = HotelMatch.where(:match_id => source_hotel.id,
                                      :match_model => source_hotel.class.to_s,
                                      :source_model => dataset).order_by_weights

          puts "dataset: #{dataset} m1:#{matches1.count} m2:#{matches2.count}"
        #  if matches1.empty? and matches2.empty?
        #    puts "No matches found. Adding."
        #    source_hotel.create_poi
        #    flag_insert = false
        #
        #    count[:add] += 1
        #    break
        #  end
        #
          if HotelMatchUtil.update_poi_id_if_match_passes_poi_dataset(dataset, source_hotel, matches1, DATA_MATCH[:low_name_threshold], DATA_MATCH[:low_address_threshold])
            flag_insert = false
            count[:update_poi_id] += 1
          end

          if HotelMatchUtil.update_poi_id_if_high_match_passes_dataset(dataset, source_hotel, matches1, DATA_MATCH[:approximate_name_threshold], DATA_MATCH[:approximate_address_threshold])
            flag_insert = false
            count[:update_poi_id] += 1
          end

          if HotelMatchUtil.update_poi_id_if_match_passes_poi_dataset(dataset, source_hotel, matches2, DATA_MATCH[:low_name_threshold], DATA_MATCH[:low_address_threshold])
            flag_insert = false
            count[:update_poi_id] += 1
          end

          if HotelMatchUtil.update_poi_id_if_high_match_passes_dataset(dataset, source_hotel, matches2, DATA_MATCH[:approximate_name_threshold], DATA_MATCH[:approximate_address_threshold])
            flag_insert = false
            count[:update_poi_id] += 1
          end

        end
        #
        ##puts "flag_insert: #{flag_insert}"
        #if flag_insert
        #  puts "Matches no good. Adding."
        #  source_hotel.create_poi
        #  count[:add] += 1
        #end

      end

      puts "Total: add:#{count[:add]} update_poi_id:#{count[:update_poi_id]}"
    end

  end

  desc "Search for 'Poi' matches using Sphinx, update source_hotel.poi_id and creates partner_hotel"
  task :search => [:environment] do
    count = {}
    count[:processing] = count[:update_count] = 0

    require 'fuzzystringmatch'
    include FuzzyStringMatch
    include PartnerHotelUtil

    dataset_all = DATA_MATCH[:dataset].split(",")
    jarow = JaroWinkler.create( :native )

    #["AsiaRoom", "PricelineBooking", "Agoda", "HotelsCombined"].each do |base_hotel|
    ["AsiaRoom"].each do |base_hotel|
      source_hotels = base_hotel.constantize.currently_valid.not_poi_matched#limit(20)
      total = source_hotels.count

      source_hotels.each do |source_hotel|
        puts "------------------------------------------------------"
        puts "Processing #{count[:processing]}/#{total} #{base_hotel} id:#{source_hotel.id} n:#{source_hotel.name} \
d:#{source_hotel.city_name} a:#{source_hotel.full_address}"

        tried_keywords = []

        keywords = "#{source_hotel.hotel_name}"
        tried_keywords.push(keywords)

        begin
          search_again = true

          pois = Poi.search("#{keywords} #{source_hotel.country_name}")
          puts "Search '#{keywords}': #{pois.count}"

          if pois.count <= 2
            pois.each_with_weighting do |poi, search_weight|
              weight_name = jarow.getDistance(keywords, poi.name)
              weight_address = jarow.getDistance(source_hotel.full_address, poi.full_address)

              puts "search_weight:#{search_weight}  weight_name:#{weight_name} weight_address: #{weight_address}"
              puts "id:#{poi.id} n:#{poi.name} a:#{poi.full_address}"

              if search_weight > 2 and (weight_name > DATA_MATCH[:extremely_wild_guess_name_threshold] or
                  weight_address > DATA_MATCH[:extremely_wild_guess_address_threshold])
                puts "Matched #{poi.id}"
                search_again = false

                create_match(poi, source_hotel, weight_name, weight_address, "search")

                if source_hotel.save_poi_id(poi.id)
                  puts "Updated: poi_id=#{source_hotel.poi_id} for #{source_hotel.class.to_s}(#{source_hotel.id})"

                  if PartnerHotelUtil.create_safely(source_hotel, poi)
                    count[:update_count] += 1
                  end
                end

              end
            end
          elsif pois.count >=3 and pois.count <= 5
            pois.each_with_weighting do |poi, search_weight|
              weight_name = jarow.getDistance(keywords, poi.name)
              weight_address = jarow.getDistance(source_hotel.full_address, poi.full_address)

              puts "search_weight:#{search_weight}  weight_name:#{weight_name} weight_address: #{weight_address}"
              puts "id:#{poi.id} n:#{poi.name} a:#{poi.full_address}"

              if search_weight > 2 and (weight_name > DATA_MATCH[:wild_guess_name_threshold] or
                  weight_address > DATA_MATCH[:wild_guess_address_threshold])
                puts "Matched #{poi.id}"
                search_again = false

                create_match(poi, source_hotel, weight_name, weight_address, "search")

                if source_hotel.save_poi_id(poi.id)
                  puts "Updated: poi_id=#{source_hotel.poi_id} for #{source_hotel.class.to_s}(#{source_hotel.id})"

                  if PartnerHotelUtil.create_safely(source_hotel, poi)
                    count[:update_count] += 1
                  end
                end

              end
            end
          end

          if search_again
            do_not_skip = true

            if do_not_skip and not tried_keywords.include? source_hotel.hotel_name_alias
              keywords = source_hotel.hotel_name_alias
              tried_keywords.push(keywords)
              do_not_skip = false
            end

            if keywords.split(" ").count >= 2 and keywords.length > 2
              relaxed_keyword = keywords.split(" ")[0..-2].join(" ")
              if do_not_skip and not tried_keywords.include? relaxed_keyword
                keywords = relaxed_keyword
                tried_keywords.push(keywords)
              end
            else
              break
            end
          end
        end while search_again

        count[:processing] += 1

      end
    end

    puts "Processed #{count[:processing]} records. Updated: #{count[:update_count]}"

  end

end