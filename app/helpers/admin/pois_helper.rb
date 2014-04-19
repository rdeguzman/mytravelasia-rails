module Admin::PoisHelper
  
  def poi_info(text, options = {})
    if text != "NULL" && text != nil && text.strip.length > 0
      content_tag(:span, text, options) + content_tag(:br)
    end
  end
  
  def poi_web_info(title, text, options = {})
    if text != "NULL" && text != nil && text.strip.length > 0
      link_text = create_web_url_links(text)
      poi_info(title, link_text, options)
    end
  end
  
  def poi_email_info(title, text, options = {})
    if text != "NULL" && text != nil && text.strip.length > 0
      link_text = create_email_links(text)
      poi_info(title, link_text, options)
    end
  end

  def create_web_url_links(text)
    final_text = ""
    
    text_array = text.split(",")
    
    text_array.each do |element|
      clean_text = element.strip.gsub("http:", "").gsub("//", "/")
      
      if clean_text.length > 0
        final_text = final_text.concat(", ") unless final_text.length == 0
        final_text << link_to(clean_text, "http://#{clean_text}", :rel => 'nofollow', :target => '_blank')
      end
      
    end
    
    raw final_text.strip
    
  end

  def create_email_links(text)
    final_text = ""
    
    text_array = text.split(",")
    
    text_array.each do |element|
      clean_text = element.strip.gsub("!", "").gsub("//", "/")
      if clean_text.length > 0
        final_text = final_text.concat(", ") unless final_text.length == 0
        final_text << link_to(clean_text, "mailto:#{clean_text}")
      end
    end
    
    raw final_text.strip
    
  end
  
end
