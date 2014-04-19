class SupportsController < ApplicationController

  def new
    @support = Support.new
  end

  def create
    @support = Support.new(params[:support])

    if verify_recaptcha(:model => @support,
                        :message => "Error with recaptcha") && @support.save
      SharedMailer.support_email(@support).deliver
      redirect_to root_path, :notice => 'Feedback email sent!'
    else
      render :action => "new"
    end
  end

end
