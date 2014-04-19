lorem_ipsum = "Lorem ipsum dolor sit amet, consectetur adipisicing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."

#This is dependent on /wwwroot/images/tsa/2. If the directory does not exist, extract sample_picture.tar.gz from ./features/upload-files
# Picture.seed do |p|
#   poi = Poi.where(:name => "Manilatest Attraction 1").first
#   p.id    = 2
#   p.caption_title = "This is the title"
#   p.caption_description = lorem_ipsum 
#   p.credits_to = "Rupert de Guzman"
#   p.credits_url = "www.google.com"
#   p.poi_id = poi.id
#   p.user_id = 1
#   p.created_at = "2011-01-04 07:05:33"
#   p.updated_at = "2011-01-04 07:05:33"
#   p.image_file_name = "test1.jpg"
#   p.image_content_type = "[image/jpeg]"
#   p.image_file_size = "265522"
#   p.image_updated_at = "2011-01-04 07:05:33"
# end

#this is now depracated as this is executed prior to pois.rb so it will fail when its looking for Manilatest