require 'bundler/gem_tasks'
require 'rake'
require 'rspec/core/rake_task'

desc "Default Task"
task :default => :spec

# Make a console for testing purposes
desc "Generate a test console"
task :console do
   verbose( false ) { sh "irb -I lib/ -r 'oauth2_hmac_header'" }
end

RSpec::Core::RakeTask.new('spec') do |t|
  t.rspec_opts = ['-c', '-r ./spec/spec_helper.rb']
  t.pattern = 'spec/**/*_spec.rb'
end