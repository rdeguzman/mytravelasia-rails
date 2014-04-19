module AgodaUtil
  def self.extract_more_button(current_page)
    begin
      main_button = current_page.find('a#ctl00_ctl00_MainContent_ContentMain_RoomTypesListGrid_v3_lbMoreRoomPlus')
      return main_button
    rescue
      return nil
    end
  end

  def self.extract_rooms(current_page)
    rooms = []

    begin
      rows = current_page.find('table.roomavaila_table').all('tr.tr553')
      rows.each do |row|
        room = {}
        room[:room_type] = row.find('td.room_name').find('span').text
        room[:price] = row.find(:css, "span[class='fontmediumb purple']").text

        if room[:price].size > 0
          room[:price] = room[:price].gsub('USD', '').strip
        end

        rooms.push(room)

        puts room
      end

      rooms = rooms.uniq
    rescue Exception => e
      puts "#{e.message}"
      #puts e.backtrace

      logger.info('AgodaUtil parsing error:')
      logger.info(e.backtrace)
    end

    return rooms
  end
end