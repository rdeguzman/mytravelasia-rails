class ChangeMinRateInParterHotels < ActiveRecord::Migration
  def self.up
    change_column :partner_hotels, :min_rate, :float, :default => 0
    execute "UPDATE partner_hotels SET min_rate = 0 WHERE min_rate is null OR min_rate = ''"
  end

  def self.down
    change_column :partner_hotels, :min_rate, :string, :default => 0
  end
end
