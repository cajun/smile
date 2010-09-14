require File.dirname(__FILE__) + '/test_helper'

Shindo.tests 'checking all the cool things smile can do'  do
  extend RR::Adapters::RRMethods

  before do
    # this resets the config to the base state before every test
    Smile::Base.clear_config!
    Smile::Base.configure do |config|
      config.logger_on = false
    end

    @smug = Smile::Smug.new
    @smug.auth_anonymously
  end

  tests 'security checks', 'security' do
    test( 'testing basic auth anonymously' ) do
      begin
        @smug.auth_anonymously
        true
      rescue
        false
      end
    end

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

  tests 'album and photo checks', 'album', 'photos' do
    test( 'checking to see if we have some albums') do 
      !@smug.albums( :nick_name => 'kleinpeter' ).empty?
    end
    
    test( 'we can reload albums from the site') do 
      album = @smug.albums( :nick_name => 'kleinpeter' ).first
      old_title = album.title
      album.title = 'foo'
      album.reload!
      old_title == album.title
    end

    test 'checking to see if we have photos in the albums' do 
      album = @smug.albums( :nick_name => 'kleinpeter' ).first
      !album.photos.empty?
    end

    test 'a photo is connected to its album'  do
      album = @smug.albums( :nick_name => 'kleinpeter' ).first
      photo = album.photos.first
      album.album_id == photo.album.album_id && 
      album.key == photo.album.key 
    end

    test( 'we can reload photos from the site') do 
      album = @smug.albums( :nick_name => 'kleinpeter' ).first
      photo = album.photos.first
      old_url = photo.tinyurl
      photo.tinyurl = 'foo'
      photo.reload!
      old_url == photo.tinyurl
    end
  end
  
  tests 'confirm configuration settings', 'config' do
    test 'there is a default api key' do
      !Smile::Base.session.api_key.nil?
    end

    test 'we can set the api key in the config' do
      Smile::Base.configure do |config|
        config.api_key = 'foo'
      end

      !Smile::Base.session.api_key.nil?
    end
  end

  tests 'there is a logger and it does stuff' do 
    test 'the logger is off by default' do
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

  tests 'looking at the params that we have to convert', ['convert'] do

    test 'classify params with first letter lower'  do
      param = [
        :popular_category, :geo_all, :geo_keyword,
        :geo_search, :geo_community, :open_search_keyword, :user_keyword,
        :nickname_recent, :nickname_popular, :user_comments, :geo_user,
        :geo_albums ]

      correct_param = [
        :popularCategory, :geoAll, :geoKeyword,
        :geoSearch, :geoCommunity, :openSearchKeyword, :userKeyword,
        :NicknameRecent, :NicknamePopular, :userComments, :geoUser,
        :geoAlbums ]
      
      failed_params = []
      correct_param.each_with_index do |correct,index|
        failed_params << param[index] if( correct != Smile::ParamConverter.convert( param[index] ) )
      end

      failed_params.empty?
    end

=begin
      when :size
        value = value.titlecase
        :Size
      when :data, :type, :description, :keywords, :geography, :position, :header,
        :clean, :filenames, :password, :public, :external, :protected, :watermarking,
        :larges, :originals, :comments, :share, :printable, :backprinting
        param.to_s.upcase.to_sym
      when :image_id, :image_key, :image_count, :nick_name, :category_id,
        :sub_category_id, :album_key, :album_template_id, :highlight_id, :square_thumbs,
        :template_id, :sort_method, :sort_direction, :password_hint, :word_searchable,
        :smug_searchable, :watermark_id, :hide_owner, :x_larges, :x2_larges, :x3_larges,
        :can_rank, :friend_edit, :family_edit, :color_correction, :default_color, :proof_days,
        :unsharp_amount, :unsharp_radius, :unsharp_sigma, :community_id
        param.to_s.classify.to_sym
      when :exif
        :EXIF
      when :api_key
        :APIKey
      when :session_id
        :SessionID
      when :album_id
        :AlbumID
      else
        key = param
    end
    
    [ key, value ]
  end
=end 
  end
end

