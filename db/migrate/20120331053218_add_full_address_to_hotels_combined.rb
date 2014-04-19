class AddFullAddressToHotelsCombined < ActiveRecord::Migration
  def self.up
    add_column :hotels_combineds, :full_address, :text
  end

  def self.down
    remove_column :hotels_combineds, :full_address
  end
end
