module SocialHelper

  def format_feed(feeds)
    feed_array = []
    feeds.each do |feed|
      poi = feed.poi

      f = {}
      f[:id] = feed.poi_id
      f[:created_at] = feed.created_at

      if feed.feed_type == "like"
        f[:age] = "#{time_ago_in_words feed.created_at} ago"
      else
        f[:age] = "posted #{time_ago_in_words feed.created_at} ago"
      end

      f[:poi_name] = feed.name
      f[:address] = poi.address
      f[:profile_id] = feed.profile_id
      f[:user] = "#{feed.first_name} #{feed.last_name}"
      f[:content] = feed.content
      f[:feed_type] = feed.feed_type
      f[:latitude] = poi.latitude
      f[:longitude] = poi.longitude
      f[:poi_type] = poi.poi_type_name
      f[:picture_thumb_path] = picture_path(poi.picture_thumb_path)
      f[:annotation_type] = "feed"
      f[:total_likes] = poi.total_likes
      f[:total_comments] = poi.total_comments
      feed_array.push(f)
    end

    return feed_array
  end

  def format_comments(comments)
    formatted_array = []

    comments.each do |entry|
      e = {}
      e[:comment_id] = entry.id
      e[:profile_id] = "#{entry.profile_id}"
      e[:name] = "#{entry.facebook_user.profile_name}"
      e[:content] = entry.content
      e[:age] = "#{time_ago_in_words(entry.created_at)} ago"
      e[:created_at] = entry.created_at
      formatted_array.push(e)
    end

    return formatted_array
  end
end