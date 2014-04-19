class AddProfileIdToApn < ActiveRecord::Migration
  def self.up
    add_column :apn_devices, :profile_id, :integer, :limit => 8
  end

  def self.down
    remove_column :apn_devices, :profile_id
  end
end
