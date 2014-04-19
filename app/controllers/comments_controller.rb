class CommentsController < ApplicationController
  def create
    pois = Poi.where(:id => params[:poi_id])

    result = {}

    if pois.empty?
      result[:valid] = false
      result[:message] = "The POI does not exist"
    else
      poi = pois.first
      comment = Comment.new
      comment.poi_id = params[:poi_id]
      comment.profile_id = params[:profile_id]
      comment.content = params[:content]

      if comment.save
        poi.total_comments = poi.total_comments + 1
        poi.save

        result[:valid] = true
        result[:message] = "Your comment was saved."
        result[:total] = poi.total_comments

        poi.notify_users(params[:profile_id], params[:content])
      else
        result[:valid] = false
        result[:message] = "Your comment was not saved. Failed Validation."
      end
    end

    respond_to do |format|
      format.json { render :json => result.to_json }
    end
  end

  def destroy
    comments = Comment.where(:id => params[:comment_id],
                         :poi_id => params[:poi_id],
                         :profile_id => params[:profile_id])

    result = {}

    if comments.empty?
      result[:valid] = false
      result[:message] = "The Comment does not exist"
    else
      comment = comments.first
      poi = comment.poi
      comment.destroy

      if comment.destroy
        poi.total_comments = poi.total_comments - 1
        poi.save

        result[:valid] = true
        result[:message] = "Your comment was deleted."
        result[:total] = poi.total_comments
      else
        result[:valid] = false
        result[:message] = "Your comment was not deleted."
      end
    end

    respond_to do |format|
      format.json { render :json => result.to_json }
    end
  end

  def update
    comments = Comment.where(:id => params[:comment_id],
                         :poi_id => params[:poi_id],
                         :profile_id => params[:profile_id])

    result = {}

    if comments.empty?
      result[:valid] = false
      result[:message] = "The Comment does not exist"
    else
      comment = comments.first
      if comment.update_attribute(:content, params[:content])

        result[:valid] = true
        result[:message] = "Your comment was updated."
        result[:total] = comment.poi.total_comments
      else
        result[:valid] = false
        result[:message] = "Your comment was not updated."
      end
    end

    respond_to do |format|
      format.json { render :json => result.to_json }
    end

  end
end
