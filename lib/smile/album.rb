# 
#  album.rb
#  smile
#  
#  Created by Zac Kleinpeter on 2009-04-28.
#  Copyright 2009 Cajun Country. All rights reserved.
# 
class Smile::Album < Smile::Base

  class << self
    def from_xml( xml, session_id )
      hash = Hash.from_xml( xml )["rsp"]
      hash["albums"]["album"].map do |album|
        album.merge!( :album_id => album["id"] )
        
        a = Smile::Album.new( album )
        a.session_id = session_id
        a
      end
    end
    
    # This will pull a single album from the smugmug
    #
    # * SessionID - string. ( by default if logged in)
    # * AlbumID - string.
    # * Password - string (optional).
    # * SitePassword - string (optional).
    # * AlbumKey - string.
    # 
    def find( options={} )
      params = default_params.merge(
          :method => 'smugmug.albums.getInfo'
      )
      
      params.merge!( options ) if( options )
      
      xml = RestClient.post Smile::Base::BASE, params
      
      album = Hash.from_xml( xml )["rsp"]["album"]
      album.merge!( :album_id => album["id"] )
      
      a = Smile::Album.new( album )
      a.session_id = session_id
      a
    end
  end

  # This will pull all the photos for a given album
  # * SessionID - string. ( by default if logged in)
  # * AlbumID - integer.
  # * Heavy - boolean (optional).
  # * Password - string (optional).
  # * SitePassword - string (optional).
  # * AlbumKey - string.
  def photos( options=nil )
    params = default_params.merge(
        :method => 'smugmug.images.get',
        :AlbumID => album_id,
        :AlbumKey => key,
        :Heavy => 1
    )

    params.merge!( options ) if( options )
    
    xml = RestClient.post BASE, params
    Smile::Photo.from_xml( xml, session_id )
  end
  
  # * integer AlbumID
  # * integer Month
  # * integer Year
  # * boolean Heavy (optional)
  def stats( options =nil )
    params = default_params.merge( 
      :method => 'smugmug.albums.getStats',
      :AlbumID => album_id,
      :month => Date.today.month,
      :year => Date.today.year
    )
    
    params.merge!( options ) if( options )
    
    xml = RestClient.post BASE, params
    rsp = Hash.from_xml( xml )["rsp"]
    raise "invalid user" if rsp["stat"] == 'fail'
    hash = Hash.from_xml( xml )["rsp"]
    OpenStruct.new( hash )
  end
end