class AddNotesToHotelsCombined < ActiveRecord::Migration
  def self.up
    add_column :hotels_combineds, :notes, :string
  end

  def self.down
    remove_column :hotels_combineds, :notes
  end
end
