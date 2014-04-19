class AsiaRoom < BasePartnerHotel
  set_table_name "asia_rooms"

  def name
    self.hotel_name
  end

  def currency_code
    "USD"
  end

  def partner_label
    "AsiaRoom"
  end

  def print_description
    super(self.partner_label)
  end

  def full_address_cleaned
    a = []

    address_cleaned_ = address_cleaned
    unless address_cleaned_.empty?
      a.push(address_cleaned_)
    end

    #remove duplicates in a string
    b = a.join(", ").strip
    b.split(",").uniq.join(",")
  end

  def web_partner_url
    if hotel_web_url.include? "?"
      prefix = "&"
    else
      prefix = "?"
    end

    http_prefix = "http://www.asiarooms.com/en"
    if hotel_web_url.include? "http://www.asiarooms.com/en"
      final_url = hotel_web_url.gsub(http_prefix, "")
      final_url = "#{http_prefix}/p/#{APP_CONFIG[:asia_room_id]}#{final_url}#{prefix}pv=aff12962_text&utm_source=aff_mytravelasia&utm_campaign=aff12962&utm_medium=affiliates&utm_content=text"
    end

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

      url = "#{self.hotel_web_url}?arrivalDate=#{start_date_formatted}&departureDate=#{end_date_formatted}&curr=USD"
      #puts url

      crawler.visit_page(url)
      crawler.wait_for_javascript
      page = crawler.page

      rooms = AsiaRoomUtil.extract_rooms(page)
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

  private
    def address_cleaned
      new_address = ""

      unless address.empty?

        new_address = address.strip

        if new_address.include? country_name
          new_address = new_address.gsub(country_name, "")
          new_address = StringUtil.remove_double_spaces(new_address)
        end

        if not new_address.include? city_name
          if new_address.ends_with? ","
            new_address = "#{new_address} #{city_name}"
          else
            new_address = "#{new_address}, #{city_name}"
          end
        end

        new_address = StringUtil.clean_commas(new_address)

      end

      return new_address.strip
    end

end
