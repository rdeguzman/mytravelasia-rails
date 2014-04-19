class WebCrawler
  attr_accessor :agent
  attr_accessor :page
  attr_accessor :error_code

  def initialize(options={})
    if options.has_key?(:javascript)
      Capybara.run_server = false

      Capybara.register_driver :selenium_chromium do |app|
        Capybara::Selenium::Driver.new(app, :browser => :chrome)
      end

      begin
        @agent = Capybara::Session.new(:selenium_chromium)
      rescue Exception => e
        puts e.backtrace
      end

    elsif options.has_key?(:mechanize)
      @agent = Mechanize.new
    end
  end

  def page_exists?(path)
    begin
      @page = @agent.get(path)

    rescue Net::HTTP::Persistent::Error => e

      @error_code = "connection_refused"
      return false

    rescue Mechanize::ResponseCodeError => e

      @error_code = "not_found"
      return false

    rescue Exception => e

      @error_code = "unknown"
      return false

    end

    return true
  end

  def visit_page(path)
    @agent.visit path
    @page = @agent
  end

  def safe_result_or_default_to(obj, default)
    if not obj.empty?
      return obj.first.text
    else
      return default
    end
  end

  def wait_for_javascript
    @agent.wait_until do
      @agent.evaluate_script('$.active') == 0
    end
  end

  def close
    begin
      @agent.driver.browser.quit
    rescue Exception => e
      puts "Cannot close browser"
      puts e.backtrace
    end
  end

end