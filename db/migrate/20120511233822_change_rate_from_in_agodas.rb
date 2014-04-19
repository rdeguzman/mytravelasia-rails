class ChangeRateFromInAgodas < ActiveRecord::Migration
  class ChangeMinRateInPois < ActiveRecord::Migration
    def self.up
      change_column :agodas, :rate_from, :float, :default => 0
      execute "UPDATE agodas SET rate_from = 0 WHERE rate_from is null OR rate_from = ''"
    end

    def self.down
      change_column :agodas, :rate_from, :string, :default => 0
    end
  end
end
