def create_match(source, target, weight_name, weight_address, match_type)
  unless HotelMatch.exists?({:source_id => source.id,
                        :source_model => source.class.to_s,
                        :match_id => target.id,
                        :match_model => target.class.to_s})
      m = HotelMatch.new
      m.source_id = source.id
      m.source_model = source.class.to_s
      m.match_id = target.id
      m.match_model = target.class.to_s
      m.match_type = match_type
      m.weight_name = weight_name
      m.weight_address = weight_address
      m.save

      puts "--------------#{match_type}-----------------------"
      puts source.print_description
      puts target.print_description
      puts "weight_name: #{weight_name}"
      puts "weight_address: #{weight_address}"

  end

end