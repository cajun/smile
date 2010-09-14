require 'bundler'
Bundler::GemHelper.install_tasks

task :default => :test

desc "Open an irb session preloaded with this library"
task :console do
    sh "irb -rubygems -r ./lib/smile.rb"
end

desc "Run Shindo rake tasks"
task :test do
  sh "shindo #{Dir.glob( 'test/**/*_test.rb' ).join(' ')}"
end

