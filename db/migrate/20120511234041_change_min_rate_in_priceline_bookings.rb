class ChangeMinRateInPricelineBookings < ActiveRecord::Migration
  def self.up
    change_column :priceline_bookings, :min_rate, :float, :default => 0
    execute "UPDATE priceline_bookings SET min_rate = 0 WHERE min_rate is null OR min_rate = ''"
  end

  def self.down
    change_column :priceline_bookings, :min_rate, :string, :default => 0
  end
end
