class AddTopDestination < ActiveRecord::Migration
  def self.up
    add_column :destinations, :top, :boolean, :default => false
  end

  def self.down
    remove_column :destinations, :top
  end
end
