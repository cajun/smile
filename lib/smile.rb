require 'activesupport'
require 'restclient'
require 'ostruct'
require 'lib/smile/base'
require 'lib/smile/smug'
require 'lib/smile/album'
require 'lib/smile/photo'
require 'cgi'
require 'rss'

module Smile
  def auth_anonymously
    smug = Smile::Smug.new
    smug.auth_anonymously
    smug
  end
  module_function( :auth_anonymously )
  
  def auth( user, pass )
    smug = Smile::Smug.new
    smug.auth( user, pass )
    smug
  end
  module_function( :auth )
  
  def base_feed( options={} )
    options.merge!( :format => 'rss' )
    url = "http://api.smugmug.com/hack/feed.mg?"
    url_params =[]
    options.each_pair do |k,value|
      case k.to_s.downcase.to_sym
        when :popular_category
          key = :popularCategory
        when :geo_all 
          key = :geoAll
        when :geo_keyword 
          key = :geoKeyword
        when :geo_search 
          key = :geoSearch
        when :geo_community
          key = :geoCommunity 
        when :open_search_keyword
          key = :openSearchKeyword
        when :user_keyword 
          key = :userkeyword
        when :nickname_recent 
          key = :nicknameRecent
        when :nickname_popular 
          key = :nicknamePopular
        when :user_comments 
          key = :userComments
        when :geo_user 
          key = :geoUser
        when :geo_album 
          key = :geoAlbum
        when :size
          key = :Size
          value = value.titlecase
        when :image_count
          key = :ImageCount
        else
          key = k
      end
      
      url_params << "#{key.to_s}=#{ CGI.escape( value ) }"
    end
    
    content = RestClient.get( url + url_params.join( "&" ) )
    RSS::Parser.parse( content, false )
  end
  module_function( :base_feed )
  
  # Search SmugMug for pics.
  # By Default it will use the keyword search.
  # 
  # options
  #   type => [ 
  #     keyword 
  #     popular # Use term all or today
  #     popularCategory # Use term category ( e.g. cars )
  #     geoAll 
  #     geoKeyword 
  #     geoSearch 
  #     geoCommunity 
  #     openSearchKeyword
  #     userkeyword # Use term nickname
  #     gallery # Use term albumID_albumKey
  #     nickname # Use term nickname
  #     nicknameRecent # Use term nickname
  #     nicknamePopular # Use term nickname
  #     usercomments # Use term nickname
  #     geoUser # Use term nickname
  #     geoAlbum # Use term albumID_albumKey
  #   ]
  def search( data, options={} )
    rss = search_raw( data, options )
    rss.items.map{ |item| item.guid.content }
    
  end
  module_function( :search )
  
  # Get the RAW feed
  def search_raw( data, options={} )
    options.merge!( :type => 'keyword', :data => data )
    base_feed( options )
  end
  module_function( :search_raw )
end

