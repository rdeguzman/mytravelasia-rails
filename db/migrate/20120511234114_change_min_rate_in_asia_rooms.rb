class ChangeMinRateInAsiaRooms < ActiveRecord::Migration
  def self.up
    change_column :asia_rooms, :min_rate, :float, :default => 0
    execute "UPDATE asia_rooms SET min_rate = 0 WHERE min_rate is null OR min_rate = ''"
  end

  def self.down
    change_column :asia_rooms, :min_rate, :string, :default => 0
  end
end
