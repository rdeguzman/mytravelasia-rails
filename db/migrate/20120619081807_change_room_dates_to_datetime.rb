class ChangeRoomDatesToDatetime < ActiveRecord::Migration
  def self.up
    change_column :rooms, :date_from, :datetime
    change_column :rooms, :date_to, :datetime
  end

  def self.down
    change_column :rooms, :date_from, :date
    change_column :rooms, :date_to, :date
  end
end
