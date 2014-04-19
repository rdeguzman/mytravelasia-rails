class CreateDestinationTypes < ActiveRecord::Migration
  def self.up
    create_table :destination_types do |t|
      t.string :name
      t.timestamps
    end
  end

  def self.down
    drop_table :destination_types
  end
end
