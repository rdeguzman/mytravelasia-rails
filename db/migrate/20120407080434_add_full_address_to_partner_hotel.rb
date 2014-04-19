class AddFullAddressToPartnerHotel < ActiveRecord::Migration
  def self.up
    add_column :partner_hotels, :full_address, :text
  end

  def self.down
    remove_column :partner_hotels, :full_address
  end
end
