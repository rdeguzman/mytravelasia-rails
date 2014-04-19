class Picture < ActiveRecord::Base
  belongs_to :poi
  belongs_to :user

  has_attached_file :image,
                    :styles => {
                      :thumb_map => ["32x32#", :jpg],
                      :thumb => ["75x75#", :jpg],
                      :thumb_big => ["120x120#", :jpg],
                      :pagesize => ["500x400>", :jpg],
                      :square => ["320x320#", :jpg],
                      #:extra_large => ["2048", :jpg],
                      :large => ["1024x768>", :jpg]
                    },
                    :convert_options => {
                      :thumb_map => '-quality 50',
                      :thumb => "-quality 50"
                    },
                    :default_style => :pagesize,
                    #:url => "/images/tsa/:id/:style/:basename.:extension",
                    #:path => "/srv/www/images/tsa/:id/:style/:basename.:extension"
                    :url => "/images/tsa/:id/:style/:normalized_file_name.:extension",
                    :path => "/srv/www/images/tsa/:id/:style/:normalized_file_name.:extension"

  validates_attachment :image, :presence => true,
                       #:content_type => { :content_type => "image/jpg" },
                       :size => { :in => 0..10.megabytes }

  #Be careful with validating the content_type, if this is set,
  #it will result to an HTTP Error reported by uploadify.swf because of the content_type
  #validates_attachment_content_type :image, :content_type => ['image/jpeg', 'image/png', 'image/gif']

  Paperclip.interpolates :normalized_file_name do |attachment, style|
    attachment.instance.normalized_file_name
  end

  def normalized_file_name
    "#{self.poi_id}-#{self.id}"
  end
  
  after_save :update_count_and_paths
  after_destroy :update_count_and_paths
  
  private
    def update_count_and_paths
      Poi.skip_callbacks = true

      poi = Poi.find_by_id(self.poi_id)
      unless poi.blank?
        total_count = poi.pictures.count + poi.web_photos.count
        poi.total_pictures = total_count

        if total_count == 1
          poi.picture_thumb_path = self.image.url(:thumb)
          poi.picture_full_path = self.image.url(:pagesize)
        elsif total_count == 0
          poi.picture_thumb_path = nil
          poi.picture_full_path = nil
        end

        poi.save
      end

      Poi.skip_callbacks = false
    end
  
end
