class AddNotesToPricelineBookings < ActiveRecord::Migration
  def self.up
    add_column :priceline_bookings, :notes, :string
  end

  def self.down
    remove_column :priceline_bookings, :notes
  end
end
