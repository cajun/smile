require 'activesupport'
require 'restclient'

class Smile
  BASE = 'http://api.smugmug.com/hack/rest/1.2.0/'
  BASE_SECURE = 'https://api.smugmug.com/hack/rest/1.2.0/'
  API = 'HSoqGCJ8ilF42BeThMGDZqqqOgj1eXqN'

  attr_accessor :session_id
  def default_params
    base = { :APIKey => API }
    if( session_id )
      base.merge!( :SessionID => session_id )
    end
    base
  end
  
  def auth( email, pass )
   params = default_params.merge(
      :method => 'smugmug.login.withPassword',
      :EmailAddress => email,
      :Password => pass
    )
    
    xml = RestClient.post( BASE, params )
    result = Hash.from_xml( xml )["rsp"]["login"]
    self.session_id = result["session"]["id"]
    result
  rescue NoMethodError => e
    nil
  end
  
  def auth_anonymously
    params = default_params.merge(
      :method => 'smugmug.login.anonymously'
    )
  
    xml = RestClient.post( BASE, params )
    result = Hash.from_xml( xml )["rsp"]["login"]
    self.session_id = result["session"]["id"]
    result
  rescue NoMethodError => e
    nil
  end
  
  def logout
    params = default_params.merge(
      :method => 'smugmug.logout'
    )
    
    RestClient.post( BASE, params )
  end
  
=begin
*  SessionID - string.
* NickName - string (optional).
* Heavy - boolean (optional).
* SitePassword - string (optional).

=end
  def albums( options=nil )
    params = default_params.merge( 
      :method => 'smugmug.albums.get',
      :heavy => 1
    )
    
    params = params.merge( options ) if( options )
    xml = RestClient.post BASE, params
    Hash.from_xml( xml )["rsp"]
  rescue
    nil
  end
  
=begin
  *  SessionID - string.
  * AlbumID - integer.
  * Heavy - boolean (optional).
  * Password - string (optional).
  * SitePassword - string (optional).
  * AlbumKey - string.
=end
    def photos( id, key, options=nil )
      params = default_params.merge(
          :method => 'smugmug.images.get',
          :AlbumID => id,
          :AlbumKey => key,
          :Heavy => 1
      )
      
      params.merge!( options ) if( options )
      RestClient.post BASE, params
    end
end