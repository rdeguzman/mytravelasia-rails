class PricelineBooking < BasePartnerHotel
  set_table_name "priceline_bookings"

  def name
    self.hotel_name
  end

  def currency_code
    "USD"
  end

  def partner_label
    "Booking"
  end

  def print_description
    super(self.partner_label)
  end

  def web_partner_url
     if hotel_web_url.include? "?"
       prefix = "&"
     else
       prefix = "?"
     end

    final_url = "#{hotel_web_url}#{prefix}aid=#{APP_CONFIG[:priceline_booking_id]}&label=#{self.poi_id}"
    return final_url
  end

  def mobile_partner_url
    return web_partner_url
  end

  def fetch_rooms(check_in=nil, check_out=nil, crawler_agent=nil)
    rooms = []

    begin
      if crawler_agent.nil?
        crawler = WebCrawler.new(:javascript => true)
      else
        crawler = crawler_agent
      end

      if check_in.nil? and check_out.nil?
        day = 60 * 60 * 24
        start_date = Time.now + (day * APP_CONFIG[:fetch_rooms_check_in_date_from_now])
        end_date = start_date + (day * 1)

        start_date_formatted = start_date.strftime("%Y-%m-%d")
        end_date_formatted = end_date.strftime("%Y-%m-%d")
      else
        tokens_check_in = check_in.split("-")
        tokens_check_out = check_out.split("-")
        start_date = Time.new(tokens_check_in[0], tokens_check_in[1], tokens_check_in[2], 0, 0, 0)
        end_date = Time.new(tokens_check_out[0], tokens_check_out[1], tokens_check_out[2], 0, 0, 0)

        start_date_formatted = start_date.strftime("%Y-%m-%d")
        end_date_formatted = end_date.strftime("%Y-%m-%d")
      end

      url = "#{hotel_mobile_url}?checkin=#{start_date_formatted};checkout=#{end_date_formatted}&selected_currency=USD"
      puts url

      crawler.visit_page(url)
      page = crawler.page

      rooms = PricelineBookingUtil.extract_rooms(page)
      #puts "Rooms.count: #{rooms.count}"

      rooms.each do |room|
        room[:date_from] = start_date.strftime("%Y-%m-%d")
        room[:date_to] = end_date.strftime("%Y-%m-%d")
        room[:currency_code] = "USD"
      end

      if crawler_agent.nil?
        crawler.close
      end

    rescue Exception => e
      if crawler_agent.nil?
        crawler.close
      end

      logger.info("Fetch Room Error: #{e.message}")
    end

    return rooms
  end


end
