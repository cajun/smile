require File.dirname(__FILE__) + '/test_helper'

Shindo.tests 'checking all the cool things smile can do'  do
  extend RR::Adapters::RRMethods

  before do
    # this resets the config to the base state before every test
    Smile::Base.clear_config!
    Smile::Base.configure do |config|
      config.logger_on = true
    end

    @smug = Smile::Smug.new
    @smug.auth_anonymously
  end

  tests 'security checks', ['security'] do
    test( 'testing basic auth anonymously' ) { @smug.auth_anonymously }

    test 'InvalidLogin will get raised on foo bar login' do
      all_good = false
      begin
        Smile.auth( 'foo', 'and mo bar' )
      rescue Smile::Exception => ex
        all_good = true
      end

      all_good
    end
  end

  tests 'album and photo checks' do
    test( 'checking to see if we have some albums', ['album']) do 
      @smug.albums( :nick_name => 'kleinpeter' ) 
    end
    
    test( 'we can reload albums from the site', ['album', 'reload']) do 
      album = @smug.albums( :nick_name => 'kleinpeter' ).first
      old_title = album.title
      album.title = 'foo'
      album.reload!
      old_title == album.title
    end

    test 'checking to see if we have photos in the albums', ['album'] do 
      album = @smug.albums( :nick_name => 'kleinpeter' ).first
      !album.photos.empty?
    end

    test 'a photo is connected to its album', ['photo'] do
      album = @smug.albums( :nick_name => 'kleinpeter' ).first
      photo = album.photos.first
      album.album_id == photo.album.album_id && 
      album.key == photo.album.key 
    end

    test( 'we can reload photos from the site', ['photo', 'reload']) do 
      album = @smug.albums( :nick_name => 'kleinpeter' ).first
      photo = album.photos.first
      old_url = photo.tinyurl
      photo.tinyurl = 'foo'
      photo.reload!
      old_url == photo.tinyurl
    end
  end
  
  tests 'confirm configuration settings', ['config'] do
    test 'there is a default api key' do
      Smile::Base.session.api_key
    end

    test 'we can set the api key in the config' do
      Smile::Base.configure do |config|
        config.api_key = 'foo'
      end

      Smile::Base.session.api_key
    end
  end

  tests 'there is a logger and it does stuff' do 
    test 'the logger is off by default', ['log'] do
      Smile::Base.clear_config!
      !Smile::Base.logger_on?
    end
  end

  tests 'looking now at the exception classes', ['exceptions'] do
    test 'exceptions should log errors' do
      @@error_got_called = false
      mock(Smile::Base.logger).error( 'foo' ) { @@error_got_called = true }
      Smile::Exception.new( 'foo' )
      @@error_got_called
    end
  end
end

