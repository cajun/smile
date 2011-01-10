require 'bundler'
require 'rake/testtask'
Bundler::GemHelper.install_tasks

Rake::TestTask.new(:test) do |test|
  test.libs << 'lib' << 'spec'
  test.pattern = './spec/**/*_spec.rb'
  test.verbose = true
end

task :default => :test

desc "Open an irb session preloaded with this library"
task :console do
    sh "irb -rubygems -r ./lib/smile.rb"
end

