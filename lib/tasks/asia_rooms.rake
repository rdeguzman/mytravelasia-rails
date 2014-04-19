def get_long_lat(text)

end

namespace :asia_rooms do
  task :backup => [:environment] do
    database_backup("asia_rooms")
  end

  namespace :seed do
    task :main => [:environment] do
      crawler = WebCrawler.new
      http_prefix = "http://www.asiarooms.com/en"

      link_queue = []

      Country.all.each do |country|
      #Country.where(:country_name => ["Myanmar"]).each do |country|
        country_link = "#{http_prefix}/#{country.name.downcase.underscore}/index.html"
        link_queue.push("#{country.name}|#{country_link}")

        begin
          if crawler.page_exists?(country_link)
            next_link = nil
            current_page = crawler.page

            area_list = current_page.search("div#areas-filter").search("a")

            if not area_list.empty?
              area_list.each do |area_link|
                link_queue.push("#{country.name}|#{http_prefix}/#{area_link['href']}")
              end
            end

          end
        end
      end

      count = 1
      link_queue.each do |queued_link|

        country_name = queued_link.split("|").first
        current_link = queued_link.split("|").last

        begin
          if crawler.page_exists?(current_link)
            puts "current_link: #{current_link}"
            next_link = nil
            current_page = crawler.page

            hotel_list = current_page.search("ul.hotel-list li")
            hotel_list.each do |hotel_node|
              if not hotel_node["id"].blank?
                hotel_id = hotel_node["id"].gsub("hotel-", "")
              end

              current_hotel = AsiaRoom.find_by_id(hotel_id)
              if current_hotel.blank?
                puts "#{count} #{hotel_id}"

                target_hotel = AsiaRoom.new
                target_hotel.id = hotel_id

                hotel_title = hotel_node.search("a[class='hotel-title']").first
                target_hotel.hotel_name = StringUtil.clean hotel_title.text
                target_hotel.hotel_web_url = http_prefix + "/" + hotel_title["href"]
                target_hotel.hotel_mobile_url = target_hotel.hotel_web_url

                target_hotel.address = AsiaRoomUtil.extract_partial_address_from_list(hotel_node)

                coord = AsiaRoomUtil.extract_long_lat(hotel_node["class"])
                target_hotel.latitude = coord[:latitude]
                target_hotel.longitude = coord[:longitude]

                target_hotel.min_rate = AsiaRoomUtil.extract_hotel_price(hotel_node)

                hotel_link = hotel_title["href"].split("/")
                country = Country.find_by_country_name(country_name)
                target_hotel.city_name = hotel_link.second.titleize.gsub("_", " ")

                target_hotel.country_id = country.id
                target_hotel.country_name = country.country_name

                puts target_hotel.print_description
                target_hotel.save!

                count += 1
              end

            end

            next_link = AsiaRoomUtil.extract_next_from_hotel_list(current_page)

            if not next_link.blank?
              current_link = http_prefix + next_link
              puts "Next Page exists: #{current_link}"

              sleep 1
            else
              break
            end

          end
        end while next_link != nil

      end

    end

    task :more_details => [:environment] do
      count = 1

      crawler = WebCrawler.new
      source_hotels = AsiaRoom.recently_added
      #source_hotels = AsiaRoom.where(:id => [40248, 199588, 213898, 177908])
      total = source_hotels.count

      source_hotels.each do |hotel|
        if crawler.page_exists?(hotel.hotel_web_url)
          puts "--------#{hotel.hotel_web_url}"
          current_page = crawler.page

          raw_address = crawler.safe_result_or_default_to(current_page.search("div.location"), "")
          full_address = AsiaRoomUtil.extract_full_address(raw_address)

          hotel_description = crawler.safe_result_or_default_to(
                        current_page.search("div.description").search("span.visible-content"), "")

          number_of_reviews = AsiaRoomUtil.extract_number_of_reviews(
              crawler.safe_result_or_default_to(current_page.search("p.basedon"), "0"))

          total_ratings = AsiaRoomUtil.extract_ratings(current_page.search("div.rating-circle"))

          hotel.address = StringUtil.clean full_address
          hotel.full_address = hotel.full_address_cleaned
          hotel.hotel_description = StringUtil.clean hotel_description
          hotel.number_of_reviews = StringUtil.clean number_of_reviews
          hotel.total_ratings = StringUtil.clean total_ratings
          hotel.current_status = "valid"
          hotel.save


          puts "Processing #{count}/#{total}: hotel.id:#{hotel.id}"
          puts "address: #{hotel.full_address}"
          puts "description: #{hotel.hotel_description}"
          puts "number_of_reviews: #{hotel.number_of_reviews}"
          puts "total_ratings: #{hotel.total_ratings}"
          count += 1
        end
      end

    end

    task :update_full_address => [:environment] do
      count = 0

      hotels = AsiaRoom.where("full_address is null")
      total = hotels.count

      hotels.each do |hotel|
        hotel.full_address = hotel.full_address_cleaned
        hotel.save

        count += 1
        puts "#{count}/#{total} #{hotel.full_address_cleaned}"
      end

      puts "Updated #{count} hotels"
    end

    task :update_hotel_mobile_url => [:environment] do
      count = 0

      hotels = AsiaRoom.where("hotel_mobile_url is null")
      total = hotels.count

      hotels.each do |hotel|
        hotel.hotel_mobile_url = hotel.hotel_web_url
        hotel.save

        count += 1
        puts "#{count}/#{total} #{hotel.hotel_mobile_url}"
      end

      puts "Updated #{count} hotels"
    end

  end

end