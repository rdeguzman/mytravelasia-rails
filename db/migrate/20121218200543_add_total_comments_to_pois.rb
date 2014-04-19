class AddTotalCommentsToPois < ActiveRecord::Migration
  def self.up
    add_column :pois, :total_comments, :integer, :default => 0
  end

  def self.down
    remove_column :pois, :total_comments
  end
end
