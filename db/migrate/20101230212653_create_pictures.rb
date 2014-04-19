class CreatePictures < ActiveRecord::Migration
  def self.up
    create_table :pictures do |t|
      t.string :caption_title
      t.text :caption_description
      t.string :credits_to
      t.string :credits_url
      
      t.references :poi
      t.references :user

      t.timestamps
    end
  end

  def self.down
    drop_table :pictures
  end
end
