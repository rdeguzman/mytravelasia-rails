class AddPoiIdIndexToPartnerHotels < ActiveRecord::Migration
  def self.up
    add_index :partner_hotels, :poi_id
  end

  def self.down
    remove_index :partner_hotels, :poi_id
  end
end
