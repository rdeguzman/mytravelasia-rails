class Agoda < BasePartnerHotel
  set_table_name "agodas"

  scope :no_ratings, :conditions => 'number_of_reviews = 0 AND user_rating_average = 0'
  scope :no_rate, :conditions => 'rate_from is null OR rate_from = ""'

  def name
    self.hotel_name
  end

  #This is in USD
  def min_rate
    self.rate_from
  end

  def currency_code
    "USD"
  end

  def partner_label
    "Agoda"
  end

  def print_description
    super(self.partner_label)
  end

  def description_cleaned
    text = super
    return StringUtil.remove_last_sentence(text)
  end

  def full_address_cleaned
    a = []

    address_cleaned_ = address_cleaned
    unless address_cleaned_.empty?
      a.push(address_cleaned_)
    end

    unless area_name.blank?
      area_name_cleaned_ = area_name_cleaned
      unless area_name_cleaned_.empty?
        a.push(area_name_cleaned_)
      end
    end

    unless city_name.blank?
      city_name_cleaned_ = city_name_cleaned
      unless city_name_cleaned_.empty?
        a.push(city_name_cleaned_)
      end
    end

    unless zip_code.blank?
      a.push(zip_code)
    end

    #remove duplicates in a string
    b = a.join(", ").strip
    b.split(",").uniq.join(",")
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

        start_date_formatted = start_date.strftime("%m/%d/%Y")
        end_date_formatted = end_date.strftime("%m/%d/%Y")
      else
        tokens_check_in = check_in.split("-")
        tokens_check_out = check_out.split("-")
        start_date = Time.new(tokens_check_in[0], tokens_check_in[1], tokens_check_in[2], 0, 0, 0)
        end_date = Time.new(tokens_check_out[0], tokens_check_out[1], tokens_check_out[2], 0, 0, 0)

        start_date_formatted = start_date.strftime("%m/%d/%Y")
        end_date_formatted = end_date.strftime("%m/%d/%Y")
      end

      url = "http://ajaxsearch.partners.agoda.com/pages/agoda/default/waitpage.aspx?waitpage=hotel&fromInternal=1&cid=12345&countryID=#{self.country_id}&cityID=#{self.city_id}&HotelID=#{self.id}&CheckIn=#{start_date_formatted}&CheckOut=#{end_date_formatted}&Rooms=1&Adults=2&Children=0&currency=USD"
      puts url

      crawler.visit_page(url)
      crawler.wait_for_javascript
      page = crawler.page

      more_button = AgodaUtil.extract_more_button(page)
      if more_button
        more_button.click
        crawler.wait_for_javascript
      end

      rooms = AgodaUtil.extract_rooms(page)
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


  def create_poi
    current = Poi.where(:name => self.name, :address => self.address, :country_name => self.country_name)

    if current.empty?

      poi = Poi.new
      poi.name = self.name
      poi.address = self.address
      poi.full_address = self.full_address_cleaned
      poi.tel_no = self.phone_number
      poi.longitude = self.longitude
      poi.latitude = self.latitude

      poi.poi_type_id = 2
      poi.poi_type_name = "Hotel"

      poi.description = self.description_cleaned

      poi.current_status = "new"

      poi.total_stars = self.user_rating_average
      poi.total_ratings = self.number_of_reviews
      poi.min_rate = self.rate_from
      poi.currency_code = "USD"

      if not self.images.blank?
        poi.picture_thumb_path = self.images.split("|").first
        poi.picture_full_path = self.images.split("|").first
      end

      country = Country.find_by_country_name(self.country_name)
      destination = DestinationUtil.find_or_create(self.city_name, country.country_name)

      unless country.blank?
        poi.country_id = country.id
        poi.country_name = country.country_name
      end

      unless destination.blank?
        poi.destination_id = destination.id
        poi.destination_name = destination.name
      end

      poi.save
      puts "Poi(#{poi.id}) #{poi.name} #{poi.full_address} created."

      self.poi_id = poi.id
      self.current_status = "valid_matched"
      self.save

      self.create_photos

      return poi

    else

      return current.first

    end

  end

  def create_photos
    unless self.images.blank?

      count = 0

      image_array = self.images.split("|")

      image_array.each do |p|
        WebPhoto.create(
          :thumb_path => p,
          :full_path => p,
          :poi_id => self.poi_id,
          :user_id => 1
        )

        count += 1
      end

      p = Poi.find(self.poi_id)
      p.total_pictures=count
      p.save

      puts "Created #{count} images"

    end
  end

  def web_partner_url
     if hotel_web_url.include? "?"
       prefix = "&"
     else
       prefix = "?"
     end

    final_url = "#{hotel_web_url}#{prefix}cid=#{APP_CONFIG[:agoda_cid]}"
    return final_url
  end

  def mobile_partner_url
    return web_partner_url
  end

  private
    def address_cleaned
      new_address = ""

      unless address.empty?

        new_address = address.strip

        new_address = StringUtil.remove_double_spaces(new_address)

        if new_address.include? ","

          city_name_cleaned_ = city_name_cleaned
          area_name_cleaned_ = area_name_cleaned

          if (new_address.include? city_name_cleaned or new_address.include? area_name_cleaned_)

            temp_address = []

            new_address.split(",").each do |element|
              if element.strip == city_name_cleaned_
              elsif element.strip == area_name_cleaned_
              else
                temp_address.push(element)
              end
            end

            new_address = temp_address.join(", ")
          end

          final_address = []
          new_address.strip.split(",").each do |part|
            unless part.strip.empty?
              final_address.push(part.strip)
            end
          end

          new_address = final_address.join(", ")
        end
      end

      return new_address.strip
    end

    def area_name_cleaned
      unless area_name.blank?
        raw_area_name = area_name
        clean_area_name = raw_area_name

        if raw_area_name.downcase == "other" then
          clean_area_name = ""
        elsif raw_area_name.include? "-"
          clean_area_name = raw_area_name.split("-").last
        end

        clean_area_name.strip
      else
        ""
      end
    end

    def city_name_cleaned
      text = ""

      if area_name.blank?
        text = city_name
      else
        area_name_cleaned_ = area_name_cleaned
        if city_name != area_name_cleaned_
          if not area_name_cleaned_.include? city_name
            text = city_name
          end
        end
      end

      text.strip
    end

end
