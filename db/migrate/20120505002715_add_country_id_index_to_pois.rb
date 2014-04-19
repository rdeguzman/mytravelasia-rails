class AddCountryIdIndexToPois < ActiveRecord::Migration
  def self.up
    add_index :pois, :country_id
  end

  def self.down
    remove_index :pois, :country_id
  end
end
