class AddNotesToAgoda < ActiveRecord::Migration
  def self.up
    add_column :agodas, :notes, :string
  end

  def self.down
    remove_column :agodas, :notes
  end
end
