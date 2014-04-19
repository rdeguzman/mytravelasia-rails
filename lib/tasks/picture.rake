require "#{Rails.root}/lib/tasks/database_backup"

namespace :picture do
  task :backup => [:environment] do
    database_backup("pictures")
    database_backup("web_photos")
  end

  task :prune => [:environment] do
    puts "Pruning directories not in pictures table"

    directories = Dir["/srv/www/images/tsa/*/"]
    directories.each do |dir|
      dir_id = File.basename(dir)
      picture = Picture.find_by_id(dir_id)

      if picture.blank?
        puts "Removing #{dir_id}"
        FileUtils.rm_rf dir
      else
        poi_id = picture.poi_id
        poi = Poi.find_by_id(poi_id)
        if poi.blank?
          puts "Poi(#{poi_id}) does not exist for picture(#{picture.id})"
          picture.destroy
          FileUtils.rm_rf dir
        end
      end

    end

    Picture.all.each do |picture|
      if not File.directory?("/srv/www/images/tsa/#{picture.id}")
        puts "Directory /srv/www/images/tsa/#{picture.id} does not exists"
        picture.destroy
      end
    end
  end

  desc "retain only originals"
  task :cleanup => [:environment, :prune] do
    Picture.all.each do |picture|
      puts "------#{picture.id}----------"

      directories = Dir["/srv/www/images/tsa/#{picture.id}/*/"]
      directories.each do |dir|
        if dir.include? "original"
          Dir.foreach(dir) do |file|
            next if file == '.' or file == '..'
            if file != picture.image_file_name
              puts "Removing #{dir}#{file} #{picture.image_file_name}"
              FileUtils.rm_rf "#{dir}#{file}"
            end
          end
        else
          puts "Removing #{dir}"
          FileUtils.rm_rf dir
        end
      end
    end
  end

  task :rename_filename => [:environment, :cleanup] do
    Picture.all.each do |picture|
      path = "/srv/www/images/tsa/#{picture.id}/original"

      original_path = "#{path}/#{picture.image_file_name}"
      extension = original_path.split(".").last.downcase

      new_path = "#{path}/#{picture.normalized_file_name}.#{extension}"

      if original_path != new_path
        puts "Renaming #{original_path} to #{new_path}"
        picture.image_file_name = "#{picture.normalized_file_name}.#{extension}"
        picture.save
        FileUtils.mv(original_path, new_path, :force => true)
      end
    end
  end

  task :add => [:environment] do
    source_hotels = Agoda.find_by_sql("SELECT a.images, p.id as poi_id
    FROM pois p, partner_hotels ph, agodas a
    WHERE p.id = ph.poi_id
    AND ph.partner_type = 'Agoda'
    AND p.total_pictures = 0
    AND a.id = ph.hotel_id
    AND a.images is not null")

    total = source_hotels.count
    count = 1

    source_hotels.each do |source_hotel|
      image_list = source_hotel.images
      puts "POI_ID (#{count}/#{total}): #{source_hotel.poi_id} #{source_hotel.images}"

      image_list.split("|").each do |image|
        w = WebPhoto.new
        w.thumb_path = image
        w.full_path = image
        w.poi_id = source_hotel.poi_id
        w.user_id = 1
        if w.valid?
          w.save
        end
      end

      count += 1

    end

  end

end