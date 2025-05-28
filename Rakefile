# encoding: utf-8
require 'rake'
require 'bundler/setup'

# RSpec test task
require 'rspec/core/rake_task'
RSpec::Core::RakeTask.new(:spec) do |spec|
  spec.pattern = 'spec/**/*_spec.rb'
end

task default: :spec

# Build the gem
desc "Build the gem"
task :build do
  sh "gem build extjsizable.gemspec"
end

# Push the gem to RubyGems
desc "Push the gem to rubygems.org"
task :release => :build do
  version = File.read('VERSION').strip
  sh "gem push extjsizable-#{version}.gem"
end

# Generate RDoc (optional)
require 'rdoc/task'
RDoc::Task.new do |rdoc|
  version = File.exist?('VERSION') ? File.read('VERSION') : ""
  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "extjsizable #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end
