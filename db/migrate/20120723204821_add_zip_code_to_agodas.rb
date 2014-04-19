class AddZipCodeToAgodas < ActiveRecord::Migration
  def self.up
    add_column :agodas, :zip_code, :string
  end

  def self.down
    remove_column :agodas, :zip_code
  end
end
