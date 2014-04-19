class AddFullAddressToAgoda < ActiveRecord::Migration
  def self.up
    add_column :agodas, :full_address, :text
  end

  def self.down
    remove_column :agodas, :full_address
  end
end
