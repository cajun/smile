module Smile
  class Smug < Smile::Base
 
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
      Smile::Album.from_xml( xml, session_id )
    rescue
      nil
    end
  end
end