class AddBookableToPoi < ActiveRecord::Migration
  def self.up
    add_column :pois, :bookable, :boolean, :default => false
  end

  def self.down
    remove_column :pois, :bookable
  end
end
