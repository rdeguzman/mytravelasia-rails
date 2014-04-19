module PoiUtil

  def self.compare(final, other)
    if not other.blank?
      if other.length > final.length
        return other
      else
        return final
      end
    else
      return final
    end
  end

  #returns a poi with picture, if no pictures found return the first
  def self.merge_by_picture(poi_array)

    final_poi = nil
    final_address = ""
    final_full_address = ""
    final_tel_no = ""
    final_web_url = ""
    final_email = ""
    final_description = ""

    poi_array.each do |poi|
      if poi.total_pictures > 0
        final_poi = poi
      end

      final_address = self.compare(final_address, poi.address)
      final_full_address = self.compare(final_address, poi.full_address)
      final_tel_no = self.compare(final_address, poi.tel_no)
      final_web_url = self.compare(final_address, poi.web_url)
      final_email = self.compare(final_address, poi.email)
      final_description = self.compare(final_address, poi.description)
    end

    if final_poi == nil
      final_poi = poi_array.first
    end

    final_poi.address = final_address
    final_poi.full_address = final_full_address
    final_poi.tel_no = final_tel_no
    final_poi.web_url = final_web_url
    final_poi.email = final_email
    final_poi.description = final_description

    return final_poi
  end
end