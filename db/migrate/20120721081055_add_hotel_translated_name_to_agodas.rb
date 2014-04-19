class AddHotelTranslatedNameToAgodas < ActiveRecord::Migration
  def self.up
    add_column :agodas, :hotel_translated_name, :string
  end

  def self.down
    remove_column :agodas, :hotel_translated_name
  end
end
