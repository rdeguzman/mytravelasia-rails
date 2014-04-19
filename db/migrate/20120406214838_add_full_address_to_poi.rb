class AddFullAddressToPoi < ActiveRecord::Migration
  def self.up
    add_column :pois, :full_address, :text
  end

  def self.down
    remove_column :pois, :full_address
  end
end
