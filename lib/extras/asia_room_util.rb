module AsiaRoomUtil
  def self.extract_long_lat(text)
    coord = {:latitude => 0, :longitude => 0}

    if text.include?("lat:") and text.include?("long:")
      a = text.gsub("hotel","").strip.split(" ")
      coord[:latitude] = a.first.gsub("lat:", "").to_f
      coord[:longitude] = a.last.gsub("long:", "").to_f
    end

    return coord
  end

  def self.extract_next_from_hotel_list(current_page)
    next_link = nil

    links = current_page.search("div.pager").search("a")

    if not links.empty?
      if links.last.text.strip.downcase == "next"
        next_link = links.last["href"]
      end
    end

    if not next_link.blank? and next_link[0,1] != "/"
      next_link = "/" + next_link
    end

    return next_link
  end

  def self.extract_hotel_price(hotel_node)
    price = ""

    element = hotel_node.search("div.hotel-cost").search("span.hotel-price")
    if not element.empty?
      if element.first.text.include? "AUD"
        price = element.first.text.gsub("AUD ", "").strip
      end
    end

    return price
  end

  def self.extract_partial_address_from_list(hotel_node)
    address = hotel_node.search("address").text.gsub("Show Map","").gsub("...","").strip
    if address.length == 0
      address = "Not available"
    end

    return address
  end

  def self.extract_full_address(text)
    full_address = text.gsub("View this hotel's location on a map", "").strip
    if full_address.length == 0
      full_address =  "Not available"
    end
    return full_address
  end

  def self.extract_number_of_reviews(text)
    if text != 0
      text = text.gsub("based on", "").gsub("review", "").gsub("reviews", "").strip
    end

    return text
  end

  def self.extract_ratings(hotel_node)
    average = hotel_node.search(".average").text
    best = hotel_node.search(".best").text
    if average.to_i > 0 and best.to_i > 0
      percentage = average.to_f/best.to_f
    else
      percentage = 0
    end
    final = percentage * 5
    return final.to_s
  end

  def self.extract_rooms(current_page)
    rooms = []

    begin
      rows = current_page.find("ul.rates-matrix-room-list").all("li")
      #puts "#{rows.count}"

      rows.each do |row|
        #Do not fetch rates that are full
        if row.first(:css, "span.full").nil?
          room = {}
          room[:room_type] = row.find("h4.room-name").text
          room[:price] = row.find("div.room-price").find("span.display-total").text.gsub("USD ", "")
          rooms.push(room)
        end

        #puts room
      end

      rooms = rooms.uniq

    rescue Exception => e
      logger.info("AsiaRoomUtil parsing error:")
      logger.info(e.backtrace)
    end

    return rooms
  end

end