class RenameHotelUrlForAgodas < ActiveRecord::Migration
  def self.up
    remove_column :agodas, :hotel_web_url
    rename_column :agodas, :hotel_url, :hotel_web_url
  end

  def self.down
    rename_column :agodas, :hotel_web_url, :hotel_url
  end
end
