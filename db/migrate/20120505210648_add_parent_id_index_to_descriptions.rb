class AddParentIdIndexToDescriptions < ActiveRecord::Migration
  def self.up
    add_index :descriptions, :parent_id
  end

  def self.down
    remove_index :descriptions, :parent_id
  end
end
