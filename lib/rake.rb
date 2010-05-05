module Shindo
  class Rake
    def initialize
      desc "Run tests"
      task :tests do
        system "shindo #{FileList[ 'test/**/*_tests.rb' ].join(' ')}"
      end
    end
  end
end
