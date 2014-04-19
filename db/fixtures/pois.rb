lorem_ipsum = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

destinations = ["ManilaTest", "BoracayTest", "CebuTest"]

poi_types = [{:id => 1, :name => 'Attraction'},
              {:id => 2, :name => 'Hotel'},  
              {:id => 3, :name => 'Restaurant'}]
              
tel_nos = ["(63)(912)3080672, (632)8038105, (63)(97)3497503", "(63)(78)8469156","(632)9313948, (632)9328560", "(63)(48)4342274, (63)(48)4341368 to 71","(632)5242631 to 5242635[loc.108]","(632)6331501 to 6331510, (632)7022700 to 7022704","(63)(74)4240960, (632)6870352 [Manila Sales Office]", "(63)(74)6190367, (632)9122691, (632)9112161loc126 [Manila Sales Office]", "(63)(32)4921888, (632)5222302, (632)522233 [Manila Sales Office], (1)(800)-1888-8228 [Toll Free]", "", " ", "NULL", nil]

emails = ["info@bellaroccaresorts.com", "reserve@alegrebeachresort.com, alegresales@pldtdsl.net", " rizalreservations@thunderbird-asia.com", "divecoron_link@yahoo.com; info@divelink.com.ph; julia_arroyo@divelink.com.ph", "inquiry@matabungkay.net", "", " ", "NULL", nil]

web_urls = ["www.crownregency.com", "www.marcopolohotels.com/hotels/philippines/davao/marco_polo_davao/index.html", "www.microtel-batangas.com, www.microtelphilippines.com", "www.facebook.com/note.php?note_id=423491192528", "www.fridaysboracay.com/", "", " ", "NULL", nil]
  
destinations.each do |destination|
  for i in 1..5 do
    poi_types.each do |poi_type|
      Poi.seed do |p|
        p.name = destination.capitalize + " " + poi_type[:name].capitalize + " " + i.to_s
        p.address = destination.capitalize + " City"
        
        p.poi_type_id = poi_type[:id]
        p.poi_type_name = poi_type[:name]

        p.destination_id = destinations.index(destination) + 1
        p.destination_name = destination
        p.country_id = 200
        p.country_name = "Philippines"
        p.description = "Lorem Ipsum #{lorem_ipsum}"
        p.tel_no = tel_nos[rand(tel_nos.size)]
        p.web_url = web_urls[rand(web_urls.size)]
        p.email = emails[rand(emails.size)]
        p.longitude = ""
        p.latitude = ""
      end
    end
  end
end

Picture.seed do |p|
  poi = Poi.where(:name => "Manilatest Attraction 1").first
  p.id    = 2
  p.caption_title = "This is the title"
  p.caption_description = lorem_ipsum 
  p.credits_to = "Rupert de Guzman"
  p.credits_url = "www.google.com"
  p.poi_id = poi.id
  p.user_id = 1
  p.created_at = "2011-01-04 07:05:33"
  p.updated_at = "2011-01-04 07:05:33"
  p.image_file_name = "test1.jpg"
  p.image_content_type = "[image/jpeg]"
  p.image_file_size = "265522"
  p.image_updated_at = "2011-01-04 07:05:33"
end