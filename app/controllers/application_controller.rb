class ApplicationController < ActionController::Base
  protect_from_forgery

  # Comment the rescue_from to see the actual errors
  #rescue_from ActionController::RoutingError, :with => :render_not_found
  #rescue_from Exception, :with => :render_error

  def after_sign_in_path_for(resource_or_scope)
    if resource_or_scope.is_a?(User)
      if current_user.role == "admin"
        admin_dashboard_path
      else
        root_path
      end
    else
      root_path
    end
  end

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to access_denied_url
  end

  def find_user_agent
    if request.env['HTTP_USER_AGENT']
      user_agent = request.env['HTTP_USER_AGENT'].downcase
    else
      user_agent = 'unknown';
    end

    if user_agent.index('iphone;') or user_agent.index('iphone simulator;')
      @user_agent = 'iphone';
    elsif user_agent.index('ipad;') or user_agent.index('ipad simulator;')
      @user_agent = 'ipad';
    else
      @user_agent = 'unknown';
    end

    logger.info("user_agent: #{user_agent}")
  end

  private
    def render_not_found(exception)
      render :template => "/errors/404.html.erb", :status => 404
    end

    def render_error(exception)
      # you can insert logic in here too to log errors
      # or get more error info and use different templates
      @error_message = exception.message
      @stacktrace = exception.backtrace
      logger.info(@stacktrace)
      render :template => "/errors/500.html.erb", :status => 500
    end

end
