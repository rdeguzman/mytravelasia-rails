source "http://rubygems.org"

gem "rails", "3.0.8"
gem "mysql2", "< 0.3"

gem "devise"#, :git => "git://github.com/plataformatec/devise.git", :branch => "master"

gem "cancan"
gem "will_paginate"#, "~> 3.0.pre2"
gem "formtastic"#, "~> 1.1.0"
gem "simple-navigation"
gem "paperclip"
gem "mime-types"#, :require => "mime/types"

#gem "thinking-sphinx",
#  :git     => "git://github.com/freelancing-god/thinking-sphinx.git",
#  :branch  => "rails3",
#  :require => "thinking_sphinx"
gem "thinking-sphinx", "2.0.10"

gem "tlsmail", :git => "git://github.com/rdeguzman/tlsmail.git"
gem "enumerated_attribute"

gem "nokogiri"
gem "mechanize"

gem "googlecharts"
gem "selenium-webdriver"
gem "capybara"

gem "httparty"

gem "recaptcha", :require => "recaptcha/rails"

gem "apn_on_rails", :git => "https://github.com/rdeguzman/apn_on_rails.git", :branch => "master"
gem 'configatron', '~> 3.1.3'

group :development do
  #if RUBY_PLATFORM.downcase.include?("darwin")
  #  gem "ruby-debug-base19x", "0.11.30.pre10"
  #  gem "ruby-debug-ide", "0.4.17.beta8"
  #end

  gem "capistrano"
  gem "rvm-capistrano"

  #used for fuzzy
  #gem "amatch"
  #gem "fuzzy-string-match"

  gem "pg"
end

group :test do
  gem "rspec"
  gem "rspec-rails"

  gem "database_cleaner"

  gem "spork", "> 0.9.0.rc"

  gem "launchy"

  gem "factory_girl_rails"

  gem "guard"
  gem "guard-spork"
  gem "guard-rspec"

  gem "fuubar"
end
