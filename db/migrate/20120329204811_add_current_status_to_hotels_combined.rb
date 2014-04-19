class AddCurrentStatusToHotelsCombined < ActiveRecord::Migration
  def self.up
    add_column :hotels_combineds, :current_status, :string, :default => 'new'
  end

  def self.down
    remove_column :hotels_combineds, :current_status
  end
end
