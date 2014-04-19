class CreateDescriptionTypes < ActiveRecord::Migration
  def self.up
    create_table :description_types do |t|
      t.string :title

      t.timestamps
    end
  end

  def self.down
    drop_table :description_types
  end
end
