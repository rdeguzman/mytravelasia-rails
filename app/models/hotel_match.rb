class HotelMatch < ActiveRecord::Base
  enum_attr :match_type,  %w(exact high high-name high-address approximate low guess wild-guess extremely-wild-guess seed search)

  scope :order_by_weights, :order => "weight_name DESC, weight_address DESC"

  def self.exists?(obj={})
    !self.where("source_id = :source_id
                AND source_model = :source_model
                AND match_id = :match_id
                AND match_model = :match_model", obj).empty?
  end

  def self.find_match_datasets(id, model)
    matches = []
    matches.push(model)

    result1 = self.where(:source_id => id, :source_model => model)
    result2 = self.where(:match_id => id, :match_model => model)

    unless result1.empty?
      result1.each do |match|
        matches.push(match.match_model)
      end
    end

    unless result2.empty?
      result2.each do |match|
        matches.push(match.source_model)
      end
    end

    return matches.uniq
  end

end
