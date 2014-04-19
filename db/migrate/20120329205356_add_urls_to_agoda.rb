class AddUrlsToAgoda < ActiveRecord::Migration
  def self.up
    add_column :agodas, :hotel_web_url, :text
    add_column :agodas, :hotel_mobile_url, :text
  end

  def self.down
    remove_column :agodas, :hotel_web_url
    remove_column :agodas, :hotel_mobile_url
  end
end
