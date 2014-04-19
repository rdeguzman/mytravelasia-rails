# A sample Guardfile
# More info at https://github.com/guard/guard#readme
group :specs do

  guard :spork, :rspec_env => { 'RAILS_ENV' => 'test' } do
    watch('config/application.rb')
    watch('config/environment.rb')
    watch(%r{^config/environments/.+\.rb$})
    watch(%r{^config/initializers/.+\.rb$})
    watch('spec/spec_helper.rb')
  end

  guard :rspec, :version => 2,  :cli => '-t ~booking --drb --color --format Fuubar --format doc' do
  #guard :rspec, :version => 2,  :cli => '--drb --color --format Fuubar --format doc' do
  #guard :rspec, :version => 2,  :cli => '--drb --color --format Fuubar' do

    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^lib/(.+)\.rb$})     { |m| "spec/modules/#{m[1]}_spec.rb" }
    watch('spec/spec_helper.rb')  { "spec" }

  # # Rails example
    watch(%r{^spec/.+_spec\.rb$})
    watch(%r{^app/(.+)\.rb$})                           { |m| "spec/#{m[1]}_spec.rb" }
    watch(%r{^lib/(.+)\.rb$})                           { |m| "spec/lib/#{m[1]}_spec.rb" }
    watch(%r{^app/controllers/(.+)_(controller)\.rb$})  { "spec" }
    watch(%r{^spec/support/(.+)\.rb$})                  { "spec" }
    watch(%r{^spec/factories/(.+)\.rb$})                  { "spec" }
    watch('spec/spec_helper.rb')                        { "spec" }
    watch('config/routes.rb')                           { "spec/routing" }
    watch('app/controllers/application_controller.rb')  { "spec/controllers" }
    # Capybara request specs
    watch(%r{^app/views/(.+)/.*\.(erb|haml)$})          { "spec" }
  end

end