class AddExclusiveToPoi < ActiveRecord::Migration
  def self.up
    add_column :pois, :exclusive, :boolean, :default => false
  end

  def self.down
    remove_column :pois, :exclusive
  end
end
