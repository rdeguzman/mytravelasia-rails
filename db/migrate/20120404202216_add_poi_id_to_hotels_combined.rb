class AddPoiIdToHotelsCombined < ActiveRecord::Migration
  def self.up
    add_column :hotels_combineds, :poi_id, :integer
  end

  def self.down
    remove_column :hotels_combineds, :poi_id
  end
end
