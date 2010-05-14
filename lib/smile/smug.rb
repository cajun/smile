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
     json = secure_web_method_call(
        { :method => 'smugmug.login.withPassword', :EmailAddress => email, :Password => pass }
      )

      self.session.id = json["login"]["session"]["id"]
      json
    end

    # Login to SmugMug using an anonymously account
    # This will allow you to execute many functions, but no user specific functions
    #
    # @return [Smile::SmugMug.new] An Smug object that has been authenticated
    def auth_anonymously
      json = secure_web_method_call( { :method => 'smugmug.login.anonymously' } )

      self.session.id = json["login"]["session"]["id"]
      json 
    end

    # Close the session
    def logout
      web_method_call( { :method => 'smugmug.logout' } )
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
      json = web_method_call( 
        { :method => 'smugmug.albums.get', :heavy => 1 },
        options
      )      

      Smile::Album.from_json( json )
    end
  end
end
