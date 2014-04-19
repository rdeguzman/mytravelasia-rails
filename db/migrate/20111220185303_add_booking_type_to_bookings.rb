class AddBookingTypeToBookings < ActiveRecord::Migration
  def self.up
    add_column :bookings, :booking_type, :string, :default => 'web'
  end

  def self.down
    remove_column :bookings, :booking_type
  end
end
