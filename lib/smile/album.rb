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
  end

=begin
  *  SessionID - string.
  * AlbumID - integer.
  * Heavy - boolean (optional).
  * Password - string (optional).
  * SitePassword - string (optional).
  * AlbumKey - string.
=end
    def photos( options=nil )
      params = default_params.merge(
          :method => 'smugmug.images.get',
          :AlbumID => album_id,
          :AlbumKey => key,
          :Heavy => 1
      )

      params.merge!( options ) if( options )
      xml = RestClient.post BASE, params
      Smile::Photo.from_xml( xml, sesson_id )
    end
end