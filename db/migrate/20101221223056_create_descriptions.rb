class CreateDescriptions < ActiveRecord::Migration
  def self.up
    create_table :descriptions do |t|
      t.text :content
      t.integer :parent_id
      t.string :table_name
      t.references :description_type

      t.timestamps
    end
  end

  def self.down
    drop_table :descriptions
  end
end
