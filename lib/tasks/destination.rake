namespace :destination do

  desc "Update poi count for every destination"
  task :update_poi_count => :environment do
    Destination.update_all(:top => false)

    search_options = { }

    countries = Country.all
    #countries = Country.where(:country_name => "Sri Lanka")

    countries.each do |country|
      search_options.merge!( :with => { :country_id => country.id } )

      destinations = country.destinations
      destinations.each do |destination|
        keywords = "#{destination.name} #{country.country_name}"
        total = Poi.search_count(keywords, search_options)

        if total > APP_CONFIG[:top_destination_count]
          destination.top = true
        end

        destination.total_pois = total
        destination.save

        puts "#{keywords}: #{total}"
      end
    end

  end
end