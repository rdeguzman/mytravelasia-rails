module Admin::PicturesHelper
  def simple_upload_form?
    if params[:simple] == nil
      return false
    else
      return true
    end
  end
  
  def link_to_picture(picture, options={})
    link_to(
      image_tag( picture.image.url(options[:style_image] || :thumb),
                 :size => options[:size],
                 :class => options[:class]),
      picture.image.url(options[:style_link_to] || :original),
      {
        :title => "#{picture.image_file_name}",
        :name => "#{picture.image_file_name}",
        :rel => "nofollow",
        :class => "single_image"
      }
    )
  end

  def default_picture(thumb_path)
    pagesize_path = thumb_path.gsub('thumb', 'pagesize')
    original_path = thumb_path.gsub('thumb', 'original')
    link_to( image_tag(pagesize_path, :class => 'entry-image'),
             original_path,
             {:class => 'single_image', :rel => 'nofollow'} )
  end
  
  def link_to_web_photo(photo, options={})
    link_to(
      image_tag( photo.thumb_path, :size => options[:size], :class => options[:class]),
      photo.full_path,
      {
        :title => "#{photo.thumb_path}",
        :name => "#{photo.thumb_path}",
        :rel => "nofollow",
        :class => "single_image"
      }
    )
  end

end
