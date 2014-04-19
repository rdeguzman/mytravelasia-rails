class AddCountToCountryDestinationPoi < ActiveRecord::Migration
  def self.up
    add_column :countries, :total_pois, :integer, :default => 0
    add_column :countries, :total_destinations, :integer, :default => 0
    add_column :destinations, :total_pois, :integer, :default => 0
    add_column :destinations, :total_attractions, :integer, :default => 0
    add_column :destinations, :total_hotels, :integer, :default => 0
  end

  def self.down
    remove_column :countries, :total_pois
    remove_column :countries, :total_destinations
    remove_column :destinations, :total_pois
    remove_column :destinations, :total_attractions
    remove_column :destinations, :total_hotels
  end
end
