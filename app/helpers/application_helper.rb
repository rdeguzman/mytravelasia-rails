module ApplicationHelper
  def default_user_image
    image_tag("default_user_icon.jpg", :size => "50x50")
  end
  
  def admin_group?
    if user_signed_in?
      if current_user.role == "admin"
        true
      else
        false
      end
    end  
  end

  def partner_group?
    if user_signed_in?
      if current_user.role == "partner"
        true
      else
        false
      end
    end
  end
  
  def link_to_icon(image_path, url_path, options = {})
    link_to(
      image_tag(image_path),
      url_path,
      options
    )
  end
  
  def has_content?(obj)
    if !obj.nil? && !obj.empty?
      true
    else
      false
    end
  end
  
  def hotel_check_in_out_format(time)
    if time.length > 0
      if time.to_i > 12
        finaltime = time.to_i - 12
        format = "PM"
      elsif time.to_i < 12
        finaltime = time.to_i
        format = "AM"
      else
        finaltime = time
        format = "NOON"
      end
    
      "#{finaltime} #{format}"
    else
      ""
    end
  end
  
  def format_rate(obj, prefix="")
    "#{prefix} #{obj.currency_code} #{number_with_precision(obj.min_rate, :precision => 0, :delimiter => ',')}".strip
  end

  def format_pluralize(count, text)
    if count > 0
      pluralize(count, text)
    else
      "No #{text}"
    end
  end

  def link_to_partner_hotel(partner_hotel, options={})
    link_path = partner_hotel.web_partner_url
    
    if partner_hotel.min_rate.nil?
      link_name = "Rate Unavailable. Check Now."
    else
      link_name = "Rates from #{format_rate(partner_hotel)}"
    end
    
    link_to(
      link_name,
      link_path,
      options
    )
    
  end

  def link_to_partner_image_hotel(partner_hotel, options={})
    link_path = partner_hotel.web_partner_url

    if options.has_key?(:size)
      link_name = image_tag("partners/#{partner_hotel.partner_type}.png", :size => options[:size])
    else
      link_name = image_tag("partners/#{partner_hotel.partner_type}.png")
    end

    link_to(
      link_name,
      link_path,
      options
    )
  end

  def pad_number_with_zero(num, pad)
    "%0#{pad}d" % num
  end
  
  def marker_image_default_path(counter)
    image_path "markers/pink#{pad_number_with_zero(counter, 2)}.png"
  end

  def format_distance(d)
    _distance = d.to_f

    if _distance > 0 
      if _distance <= 1000
        "#{number_with_precision(_distance, :precision => 0)} m"
      elsif _distance > 1000 && _distance <= 100000
        _distanceInKM = _distance / 1000.0
        "#{number_with_precision(_distanceInKM, :precision => 3)} km"
      else
        _distanceInKM = _distance / 1000.0
        "#{number_with_precision(_distanceInKM, :precision => 0)} km"
      end
    end
  end

  def truncate_text(text, length, separator=' ')
    truncate(text, :length => length, :separator => separator)
  end

  def current_uri(querystring)
    if params[:controller] == 'home'
      querystring.pluralize.downcase
    elsif params[:controller] == 'countries'
      request.env['PATH_INFO'] + '/' + querystring.pluralize.downcase
    end
  end

  def picture_path(_image_path)
    final_path = nil

    if _image_path.nil? or _image_path.length == 0
      final_path = "http://#{request.host}/images/no-image.png"
    else
      if _image_path.index('http')
        final_path = _image_path
      else
        final_path = "http://#{request.host_with_port}#{_image_path}"
      end
    end

    final_path
  end

  def aggregate_images(poi, pictures, web_photos)
    images = Array.new

    for p in pictures do
      pic = {}
      pic[:id] = p.id
      pic[:poi_id] = poi.id
      pic[:caption] = p.caption_title
      pic[:thumb] = picture_path(p.image.url(:thumb))

      if poi.needs_higher_resolution?
        pic[:full] = picture_path(p.image.url(:original))
      else
        pic[:full] = picture_path(p.image.url(:pagesize))
      end

      images.push(pic)
    end

    for p in web_photos do
      photo = {}
      photo[:id] = p.id
      photo[:poi_id] = poi.id
      photo[:caption] = p.caption_title
      photo[:thumb] = p.thumb_path
      photo[:full] = p.full_path
      images.push(photo)
    end

    return images
  end

  def mobileformat_pois(_pois)
    _arrayPois = Array.new

    for p in _pois do
      _poi = {}
      _poi[:id] = p.id
      _poi[:name] = p.name
      _poi[:address] = p.address
      _poi[:description_short] = truncate(p.description, :length => 100, :seperator => ' ')
      _poi[:picture_thumb_path] = picture_path(p.picture_thumb_path)
      _poi[:latitude] = p.latitude
      _poi[:longitude] = p.longitude
      _poi[:total_stars] = p.total_stars
      _poi[:total_ratings] = p.total_ratings
      _poi[:poi_type] = p.poi_type_name
      _poi[:updated_at] = p.updated_at
      _poi[:min_rate] = format_rate(p)
      _poi[:annotation_type] = "poi"
      _poi[:total_likes] = p.total_likes
      _poi[:total_comments] = p.total_comments

      if p.sphinx_attributes && p.has_map?
        _poi[:distance] = "#{format_distance(p.sphinx_attributes['@geodist'])}"
      end

      _arrayPois.push(_poi)
    end

    return _arrayPois
  end

end
