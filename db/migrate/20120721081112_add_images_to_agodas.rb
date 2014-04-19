class AddImagesToAgodas < ActiveRecord::Migration
  def self.up
    add_column :agodas, :images, :string
  end

  def self.down
    remove_column :agodas, :images
  end
end
