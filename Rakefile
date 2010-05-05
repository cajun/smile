require 'rubygems'
require 'rake'
require 'date'

#############################################################################
##
## Helper functions
##
##############################################################################

def name
  @name ||= Dir['*.gemspec'].first.split('.').first
end

def version
  line = File.read("lib/#{name}.rb")[/^\s*VERSION\s*=\s*.*/]
  line.match(/.*VERSION\s*=\s*['"](.*)['"]/)[1]
end

def date
  Date.today.to_s
end

def rubyforge_project
  name
end

def gemspec_file
  "#{name}.gemspec"
end

def gem_file
  "#{name}-#{version}.gem"
end

def replace_header(head, header_name)
  head.sub!(/(\.#{header_name}\s*= ').*'/) { "#{$1}#{send(header_name)}'"}
end

desc "Open an irb session preloaded with this library"
task :console do
    sh "irb -rubygems -r ./lib/#{name}.rb"
end

desc "Run Shindo rake tasks"
task :test do
  sh "shindo #{Dir.glob( 'test/**/*_test.rb' ).join(' ')}"
end

begin
  require 'jeweler'
  Jeweler::Tasks.new do |gem|
    gem.name = "smile"
    gem.summary = %Q{Simple API for talking to SmugMug}
    gem.email = "zac@kleinpeter.org"
    gem.homepage = "http://github.com/cajun/smile"
    gem.authors = ["cajun"]
    gem.files << "lib/**/*"
    gem.add_dependency( 'rest-client' )
    gem.add_dependency( 'activesupport' )
    gem.rubyforge_project = 'cajun-gems'
    
    # gem is a Gem::Specification... see http://www.rubygems.org/read/chapter/20 for additional settings
  end
rescue LoadError
  puts "Jeweler not available. Install it with: sudo gem install technicalpickles-jeweler -s http://gems.github.com"
end

task :default => :test 

require 'rake/rdoctask'
Rake::RDocTask.new do |rdoc|
  if File.exist?('VERSION.yml')
    config = YAML.load(File.read('VERSION.yml'))
    version = "#{config[:major]}.#{config[:minor]}.#{config[:patch]}"
  else
    version = ""
  end

  rdoc.rdoc_dir = 'rdoc'
  rdoc.title = "smile #{version}"
  rdoc.rdoc_files.include('README*')
  rdoc.rdoc_files.include('lib/**/*.rb')
end

