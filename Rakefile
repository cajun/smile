require 'bundler'
Bundler::GemHelper.install_tasks

task :default => :test

desc "Open an irb session preloaded with this library"
task :console do
    sh "irb -rubygems -r ./lib/smile.rb"
end

task :test do
  sh "ruby #{Dir.glob('./spec/*_spec.rb').join(' ')}"
end
