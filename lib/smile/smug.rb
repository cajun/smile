# 
#  smug.rb
#  smile
#  
#  Created by Zac Kleinpeter on 2009-04-28.
#  Copyright 2009 Cajun Country. All rights reserved.
# 
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

    

    # Retrieves a list of albums for a given user. If you are logged in it will return
    # your albums.
    # 
    # Arguments
    # NickName - string (optional).
    # Heavy - boolean (optional).
    # SitePassword - string (optional).
    #
    # Result
    #     STANDARD RESPONSE
    # 
    # array Albums
    # Album
    #   integer id
    #   string Key
    #   string Title
    #   struct Category
    #   string id
    #   string Name
    #   struct SubCategory
    #   string id
    #   string Name
    #
    #     HEAVY RESPONSE
    #   
    # array Albums
    # Album
    #   integer id
    #   string Key
    #   string Title
    #   struct Category
    #     string id
    #     string Name
    #   struct SubCategory
    #     string id
    #     string Name
    #   string Description
    #   string Keywords
    #   boolean Geography (owner)
    #   integer Position
    #   struct Hightlight (owner)
    #     string id
    #   integer ImageCount
    #   string LastUpdated
    #   boolean Header (owner, power & pro only)
    #   boolean Clean (owner)
    #   boolean EXIF (owner)
    #   boolean Filenames (owner)
    #   struct Template (owner)
    #     string id
    #   string SortMethod (owner)
    #   boolean SortDirection (owner)
    #   string Password (owner)
    #   string PasswordHint (owner)
    #   boolean Public (owner)
    #   boolean WorldSearchable (owner)
    #   boolean SmugSearchable (owner)
    #   boolean External (owner)
    #   boolean Protected (owner, power & pro only)
    #   boolean Watermarking (owner, pro only)
    #   struct Watermark (owner, pro only)
    #     string id
    #   boolean HideOwner (owner)
    #   boolean Larges (owner, pro only)
    #   boolean XLarges (owner, pro only)
    #   boolean X2Larges (owner)
    #   boolean X3Larges (owner)
    #   boolean Originals (owner)
    #   boolean CanRank (owner)
    #   boolean FriendEdit (owner)
    #   boolean FamilyEdit (owner)
    #   boolean Comments (owner)
    #   boolean Share (owner)
    #   boolean Printable (owner)
    #   int ColorCorrection (owner)
    #   boolean DefaultColor (owner, pro only)  deprecated
    #   integer ProofDays (owner, pro only)
    #   string Backprinting (owner, pro only)
    #   float UnsharpAmount (owner, power & pro only)
    #   float UnsharpRadius (owner, power & pro only)
    #   float UnsharpThreshold (owner, power & pro only)
    #   float UnsharpSigma (owner, power & pro only)
    #   struct Community (owner)
    #     string id
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