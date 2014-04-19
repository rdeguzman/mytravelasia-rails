module PartnerHotelsHelper
  def format_rooms(rooms)
    formatted_array = []

    rooms.each do |room|
      r = {}
      r[:room_type] = link_to room.room_type, room.partner_url, {:rel => 'nofollow', :target => '_blank' }
      r[:currency] = room.currency_code
      r[:rate] = number_with_precision(room.rate, :precision => 2)
      r[:provider] = link_to_room_partner_image_hotel(room.partner_url, room.partner_type, {:rel => 'nofollow', :target => '_blank', :size => "100x30"})
      r[:valid_dates] = "#{room.date_from.to_s(:with_day)}<br/>#{room.date_to.to_s(:with_day)}"
      formatted_array.push(r)
    end

    return formatted_array
  end

  def link_to_room_partner_image_hotel(partner_url, partner_type, options)
    link_path = partner_url

    if options.has_key?(:size)
      link_name = image_tag("partners/#{partner_type}.png", :size => options[:size])
    else
      link_name = image_tag("partners/#{partner_type}.png")
    end

    link_to(
      link_name,
      link_path,
      options
    )
  end

  def mobileformat_partner_hotels(partner_hotels, user_agent)
    if user_agent
      if user_agent == 'ipad'
        partner_hotels.collect{ |ph| {:name => ph.partner_label, :url => ph.web_partner_url} }
      else
        partner_hotels.collect{ |ph| {:name => ph.partner_label, :url => ph.mobile_partner_url} }
      end
    else
      partner_hotels.collect{ |ph| {:name => ph.partner_label, :url => ph.mobile_partner_url} }
    end
  end

end