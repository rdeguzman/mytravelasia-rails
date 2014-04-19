class AddFeaturedToPois < ActiveRecord::Migration
  def self.up
    add_column :pois, :featured, :boolean, :default => false,  :null => false
  end

  def self.down
    remove_column :pois, :featured
  end
end
