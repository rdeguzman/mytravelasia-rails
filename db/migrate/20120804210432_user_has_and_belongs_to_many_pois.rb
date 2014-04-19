class UserHasAndBelongsToManyPois < ActiveRecord::Migration
  def self.up
    create_table :poi_user_privileges do |t|
      t.references :poi, :user
      t.boolean    :allowed, :default => false
      t.string     :allowed_by
      t.timestamps
    end
  end

  def self.down
    drop_table :poi_user_privileges
  end
end
