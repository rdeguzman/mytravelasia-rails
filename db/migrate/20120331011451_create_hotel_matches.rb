class CreateHotelMatches < ActiveRecord::Migration
  def self.up
    create_table :hotel_matches do |t|
      t.integer :source_id
      t.string  :source_model
      t.integer :match_id
      t.string  :match_model
      t.string  :match_type, :default => "guess"

      t.float   :weight_name
      t.float   :weight_address
      t.float   :weight_location

      t.timestamps
    end
  end

  def self.down
    drop_table :hotel_matches
  end
end
