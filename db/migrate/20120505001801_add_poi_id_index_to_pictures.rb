class AddPoiIdIndexToPictures < ActiveRecord::Migration
  def self.up
    add_index :pictures, :poi_id
  end

  def self.down
    remove_index :pictures, :poi_id
  end
end
