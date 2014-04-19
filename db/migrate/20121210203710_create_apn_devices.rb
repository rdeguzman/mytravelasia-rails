class CreateApnDevices < ActiveRecord::Migration # :nodoc:
  def self.up
    create_table :apn_devices do |t|
      t.text :token, :size => 71, :null => false
      t.decimal :longitude, :precision => 12, :scale => 6
      t.decimal :latitude, :precision => 12, :scale => 6

      t.timestamps
    end
  end

  def self.down
    drop_table :apn_devices
  end
end
