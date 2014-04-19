class CreateSupports < ActiveRecord::Migration
  def self.up
    create_table :supports do |t|
      t.string :name
      t.string :email
      t.string :contact
      t.text :description

      t.timestamps
    end
  end

  def self.down
    drop_table :supports
  end
end
