require File.dirname(__FILE__) + '/spec_helper'

describe Smile do
  before(:each) do
    VCR.use_cassette 'login anonymously', :record => :new_episodes do
      # this resets the config to the base state before every test
      Smile::Base.clear_config!
      Smile::Base.configure do |config|
        config.logger_on = false
      end
      @smug = Smile.auth_anonymously
      @album = @smug.albums(:nick_name => 'kleinpeter').first
    end
  end

  describe 'should have security' do
    describe 'using valid logins' do

      it 'should be able to login anonymously' do
        VCR.use_cassette 'login anonymously', :record => :new_episodes do
          Smile.auth_anonymously.must_be_instance_of Smile::Smug
        end
      end

      it 'should be able to login with a valid account' do
        VCR.use_cassette 'login with good password', :record => :new_episodes do
          Smile.auth( 'foo@example.com', 'seaKrat' ).must_be_instance_of Smile::Smug
        end
      end

    end

    describe 'using invalid logins' do

      it 'should NOT able to login without a valid account' do
        VCR.use_cassette 'login with bad password', :record => :new_episodes do
          lambda { Smile.auth( 'bar@example.com', 'seaKrat' ) }.must_raise( Smile::Exception )
        end
      end
    end

  end

  describe 'albums' do
    it 'should have albums on an nickname account' do
      VCR.use_cassette 'getting albums for a nickname', :record => :new_episodes do
        @smug.albums( :nick_name => 'kleinpeter' ).wont_be_empty
      end
    end

    describe 'have methods' do
      it 'should be able to be reloaded' do
        VCR.use_cassette 'reloading album', :record => :new_episodes do
          old_title = @album.title
          @album.title = 'foo'
          @album.reload!
          @album.title.must_equal old_title
        end
      end

      it 'should have photos' do
        VCR.use_cassette 'checking photos', :record => :new_episodes do
          @album.photos.wont_be_empty
        end
      end

    end
  end
end
