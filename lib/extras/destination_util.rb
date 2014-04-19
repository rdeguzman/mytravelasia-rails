require 'fuzzystringmatch'

module DestinationUtil
  def self.find_fuzzy(name)
    jarow = FuzzyStringMatch::JaroWinkler.create( :native )

    dest = nil

    max_weight = 0

    Destination.all.each do |d|

      weight = jarow.getDistance(d.name, name)
      #puts "w: #{weight} #{d.name} vs #{name}"

      if weight >= 0.85
        if(weight > max_weight)
          max_weight = weight
          dest = d
        end

        #puts "fuzzy matched #{weight}"
      end
    end

    return dest

  end

  def self.find(name)
    dest = Destination.find_by_destination_name(name)

    if dest.blank?
      dest = self.find_fuzzy(name)
    end

    dest
  end

  def self.find_or_create(name, country_name)
    dest = self.find(name)

    if dest.blank?
      country = Country.find_by_country_name(country_name)

      unless country.blank?
        d = Destination.new
        d.destination_name = name
        d.country_id = country.id
        d.destination_type_id = 1
        d.save!

        puts "Destination created #{name}"

        dest = d
      end

    end

    return dest
  end

end