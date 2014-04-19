class CreateCountries < ActiveRecord::Migration
  def self.up
    create_table :countries do |t|
      t.string :country_name
      t.string :country_code
      t.text :description
      t.timestamps
    end
    execute "ALTER TABLE countries AUTO_INCREMENT = 100;"
  end

  def self.down
    drop_table :countries
  end
end
