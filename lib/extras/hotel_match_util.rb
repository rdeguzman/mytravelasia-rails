module HotelMatchUtil
  def update_poi_id_if_match_passes_poi_dataset(dataset, source, matches, weight_name_threshold, weight_address_threshold)
    flag = false

    if matches.count == 1 and dataset == "Poi"
      matches.each do |match|
        target = Poi.find_by_id(match.match_id)

        unless target.blank?
          puts "Match(S): wn:#{match.weight_name} wa:#{match.weight_address} #{match.match_model}(#{target.id}):#{target.name}|#{target.full_address}"
          if match.weight_name > weight_name_threshold or match.weight_address > weight_address_threshold

            if source.save_poi_id(target.id)
              puts "Updated: poi_id=#{source.poi_id} for #{source.class.to_s}(#{source.id})"
              flag = true
            end

          end
        end
      end
    end

    return flag
  end

  def update_poi_id_if_high_match_passes_dataset(dataset, source, matches, weight_name_threshold, weight_address_threshold)
    flag = false

    if matches.count >= 1 and dataset != "Poi"
      high_match = matches.where("weight_name >= #{weight_name_threshold} or weight_address >= #{weight_address_threshold}")

      unless high_match.empty?
        matches.each do |match|
          target = match.match_model.constantize.find_by_id(match.match_id)

          unless target.blank?
            puts "Match(S): wn:#{match.weight_name} wa:#{match.weight_address} #{match.match_model}(#{target.id}):#{target.name}|#{target.full_address}"

            if high_match.count == 1 and (match.weight_name > weight_name_threshold or match.weight_address > weight_address_threshold)

              if source.save_poi_id(target.poi_id)
                puts "High Match Updated"
                flag = true
              else
                if target.poi_id.blank?
                  p = source.create_poi
                  target.poi_id = p.id
                  target.save!
                  flag = true
                else
                  target.poi_id = source.poi_id
                  target.save!
                  flag = true
                end
              end

            else
              puts "Destroying match as it does not meet threshold"
              match.destroy
            end
          end

        end
      end
    end

    return flag
  end

end