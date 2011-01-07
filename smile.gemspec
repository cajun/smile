# -*- encoding: utf-8 -*-
require File.expand_path("../lib/smile/version", __FILE__)

Gem::Specification.new do |s|
  s.name     = %q{smile}
  s.version  = Smile::VERSION
  s.platform = Gem::Platform::RUBY
  s.authors  = ["cajun"]
  s.email    = %q{zac@kleinpeter.org}
  s.date     = %q{2010-07-09}
  s.homepage = %q{http://github.com/cajun/smile}
  s.summary  = %q{Simple API for talking to SmugMug}

  s.rdoc_options = ["--charset=UTF-8"]

  s.required_rubygems_version = ">= 1.3.6"
  s.rubyforge_project = 'smile'

  s.add_dependency 'rest-client', ">= 0"
  s.add_dependency 'activesupport', ">= 3.0"
  s.add_dependency 'i18n'
  s.add_dependency 'yajl-ruby', '>= 0.7.8'

  s.add_development_dependency "bundler", ">= 1.0.0"
  s.add_development_dependency "minitest"
  s.add_development_dependency "vcr"
  s.add_development_dependency "fakeweb"


  s.files        = `git ls-files`.split("\n")
 # s.executables  = `git ls-files`.split("\n").map{|f| f =~ /^bin\/(.*)/ ? $1 : nil}.compact
  s.require_path = 'lib'

  s.extra_rdoc_files = [
    "LICENSE",
     "README.rdoc"
  ]

  s.test_files = [
    "test/smile_test.rb",
     "test/test_helper.rb"
  ]
end
