# 
#  smug.rb
#  smile
#  
#  Created by Zac Kleinpeter on 2009-04-28.
#  Copyright 2009 Cajun Country. All rights reserved.
# 
module Smile
  class Smug < Smile::Base
 
    # Login to SmugMug using a specific user account.
    #
    # @param [String] email The username ( Nickname ) for the SmugMug account
    # @param [String] password The password for the SmugMug account
    #
    # @return [Smile::SmugMug.new] An Smug object that has been authenticated
    def auth( email, pass )
     params = default_params.merge(
        :method => 'smugmug.login.withPassword',
        :EmailAddress => email,
        :Password => pass
      )

      json = RestClient.post( BASE, params )
      result = JSON.parse( json )
      
      self.session_id = result["Login"]["Session"]["id"]
      result
    rescue NoMethodError => e
      nil
    end

    # Login to SmugMug using an anonymously account
    # This will allow you to execute many functions, but no user specific functions
    #
    # @return [Smile::SmugMug.new] An Smug object that has been authenticated
    def auth_anonymously
      params = default_params.merge(
        :method => 'smugmug.login.anonymously'
      )

      json = RestClient.post( BASE, params )
      result = JSON.parse( json )
      self.session_id = result["Login"]["Session"]["id"]
      result
    rescue NoMethodError => e
      nil
    end

    # Close the session
    def logout
      params = default_params.merge(
        :method => 'smugmug.logout'
      )

      RestClient.post( BASE, params )
    end

    

    # Retrieves a list of albums for a given user. If you are logged in it will return
    # your albums.
    # 
    # @param [optional,Hash] options The magic options hash all ruby devs love
    # @option options [optional, String] :nick_name If no nick name is supplied then...
    # @option options [optional, true or false ] :heavy ('true') This will control how much 
    # information is returned about the album
    # @option options [optional, String] :site_password If you have not logged in then you can provide the 
    # password here to access private information.
    #
    # @return [Array<Smile::Album>]
    # 
    # @see Smug::Album#new For more information about heavy ( true and false ) responces
    def albums( options=nil )
      params = default_params.merge( 
        :method => 'smugmug.albums.get',
        :heavy => 1
      )      

      options = Smile::ParamConverter.clean_hash_keys( options )
      params = params.merge( options ) if( options )
      json = RestClient.post BASE, params

      Smile::Album.from_json( json, session_id )
    rescue
      nil
    end
  end
end
