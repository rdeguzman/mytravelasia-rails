default_run_options[:pty] = true

set :application, "mytravel-asia"
set :rvm_ruby_string, 'ruby-2.1.1@mytravel-asia'
set :rvm_type, :user

require "bundler/capistrano"
require "rvm/capistrano"

set :repository,  "https://github.com/rdeguzman/mytravelasia-rails.git"
set :deploy_to, "/srv/rails/#{application}"

set :scm, :git

# robin = 173.255.249.114
role :web, "robin"                          # Your HTTP server, Apache/etc
role :app, "robin"                          # This may be the same as your `Web` server
role :db,  "robin", :primary => true # This is where Rails migrations will run

set :user, "rupert"
set :port, 22
set :use_sudo, false

set :keep_releases, 10

namespace :deploy do
  namespace :web do
    desc <<-DESC
      Present a maintenance page to visitors. Disables your application's web \
      interface by writing a "maintenance.html" file to each web server. The \
      servers must be configured to detect the presence of this file, and if \
      it is present, always display it instead of performing the request.

      By default, the maintenance page will just say the site is down for \
      "maintenance", and will be back "shortly", but you can customize the \
      page by specifying the REASON and UNTIL environment variables:

        $ cap deploy:web:disable \\
              REASON="a hardware upgrade" \\
              UNTIL="12pm Central Time"

      Further customization will require that you write your own task.
    DESC
    task :disable, :roles => :web do
      require 'erb'
      on_rollback { run "rm #{shared_path}/system/maintenance.html" }

      reason = ENV['REASON']
      deadline = ENV['UNTIL']
      template = File.read('app/views/shared/maintenance.html.erb')
      page = ERB.new(template).result(binding)

      put page, "#{shared_path}/system/maintenance.html", :mode => 0644
    end
  end

  task :start do ; end
  task :stop do ; end

  task :restart do
    run "ln -s /srv/www/images/tsa /srv/rails/#{application}/current/public/images/tsa"
    run "ln -s /srv/rails/#{application}/shared/rvmrc /srv/rails/#{application}/current/.rvmrc"
    run "ln -s /srv/rails/#{application}/shared/database.yml /srv/rails/#{application}/current/config/database.yml"

    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end

end