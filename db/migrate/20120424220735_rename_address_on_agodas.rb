class RenameAddressOnAgodas < ActiveRecord::Migration
  def self.up
    rename_column :agodas, :address_i, :address
  end

  def self.down
    rename_column :agodas, :address, :address_i
  end
end
