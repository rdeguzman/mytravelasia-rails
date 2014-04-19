class Feed < ActiveRecord::Base
  set_table_name "feeds"
  belongs_to :poi

  scope :latest, :order => "created_at DESC"

  def feed_type
    if self.content == "like this"
      "like"
    else
      "comment"
    end

  end
end