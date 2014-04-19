def prefix_url
  "http://www.booking.com"
end

def clean_hotel_url(text)
  prefix_url + text.split("?").first
end

def get_city_name_from_link(text)
  final_text = ""

  if text.include? ","
    a = text.split(",")
    if a.count >= 2
      final_text = a.last
    end
  end

  return final_text
end

namespace :priceline_booking do

  task :backup => [:environment] do
    database_backup("priceline_bookings")
  end

  namespace :seed do
    task :main => [:environment] do
      count = 1

      crawler = WebCrawler.new

      Country.all.each do |country|
        current_link = "http://www.booking.com/searchresults.html?aid=347779&country=#{country.country_code}"

        begin
          if crawler.page_exists?(current_link)
            next_link = nil
            current_page = crawler.page

            #this is a <tr> node
            tr_nodes = current_page.search("table.hotellist").search("tr")

            tr_nodes.each do |tr|
              puts "------------------------"

              hotel_node = tr.search(".//a[@class='hotel_name_link url ']").first
              #puts "hotel_node: #{hotel_node}"

              if not tr["id"].blank?
                hotel_id = tr["id"].gsub("hotel_item_","")
              end

              current_hotel = PricelineBooking.find_by_id(hotel_id)
              if current_hotel.blank?
                target_hotel = PricelineBooking.new
                target_hotel.id = hotel_id

                target_hotel.hotel_name = hotel_node.text
                target_hotel.hotel_web_url = clean_hotel_url hotel_node['href']
                target_hotel.hotel_mobile_url = target_hotel.hotel_web_url

                target_hotel.city_name = get_city_name_from_link hotel_node['title']
                target_hotel.country_id = country.id
                target_hotel.country_name = country.country_name

                coordinates_node = tr.search(".//a[@class='show_map']")
                if not coordinates_node.blank?
                  coordinates = coordinates_node.first["data-coords"]
                  target_hotel.longitude = coordinates.split(",").first
                  target_hotel.latitude = coordinates.split(",").last
                end

                puts target_hotel.print_description
                target_hotel.save!

                puts "#{count}"
                count += 1
              end

            end

            next_page = current_page.search("td.next").search("a")

            if not next_page.blank?
              #puts "next_page: #{next_page}"
              next_link = next_page.first["href"]
              current_link = prefix_url + next_link
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
      source_hotels = PricelineBooking.recently_added
      total = source_hotels.count

      source_hotels.each do |hotel|
        if crawler.page_exists?(hotel.hotel_web_url)
          puts "--------#{hotel.hotel_web_url}"
          current_page = crawler.page

          full_address = crawler.safe_result_or_default_to(current_page.search("p.address").search("span"), "")
          hotel_description = crawler.safe_result_or_default_to(current_page.search("div#summary"), "")
          number_of_reviews = crawler.safe_result_or_default_to(current_page.search("strong.count"), "0")
          total_ratings = crawler.safe_result_or_default_to(current_page.search("span.average"), "0")

          hotel.address = StringUtil.clean full_address
          hotel.full_address = StringUtil.clean full_address
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

    task :update_hotel_mobile_url => [:environment] do
      count = 0

      hotels = PricelineBooking.where("hotel_mobile_url is null")
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