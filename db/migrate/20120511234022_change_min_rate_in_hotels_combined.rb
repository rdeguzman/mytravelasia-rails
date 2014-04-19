class ChangeMinRateInHotelsCombined < ActiveRecord::Migration
  def self.up
    change_column :hotels_combineds, :min_rate, :float, :default => 0
    execute "UPDATE hotels_combineds SET min_rate = 0 WHERE min_rate is null OR min_rate = ''"
  end

  def self.down
    change_column :hotels_combineds, :min_rate, :string, :default => 0
  end
end
