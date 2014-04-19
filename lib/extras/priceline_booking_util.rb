module PricelineBookingUtil

  def self.extract_rooms(current_page)
    rooms = []

    begin
      rows = current_page.find('ul.m_hp_rooms_table_2').all('li')
      #puts "#{rows.count}"

      rows.each do |row|
        #puts "#{row.text}"

        room = {}
        room[:room_type] = row.find('h2').text
        room[:price] = row.find(:css, "span[class='price ']").text.gsub("US$ ", '')

        rooms.push(room)

        puts room
      end

      rooms = rooms.uniq

    rescue Exception => e
      puts "#{e.message}"
      #puts e.backtrace

      logger.info('PricelineBookingUtil parsing error:')
      logger.info(e.backtrace)
    end

    return rooms
  end
end