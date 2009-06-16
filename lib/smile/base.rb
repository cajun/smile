# 
#  base.rb
#  smile
#  
#  Created by Zac Kleinpeter on 2009-04-28.
#  Copyright 2009 Cajun Country. All rights reserved.
# 
module Smile
  class Base < OpenStruct
    BASE = 'http://api.smugmug.com/hack/rest/1.2.0/'
    BASE_SECURE = 'https://api.smugmug.com/hack/rest/1.2.0/'
    API = 'HSoqGCJ8ilF42BeThMGDZqqqOgj1eXqN'

    class << self
      attr_accessor :session_id
      # This will be included in every request once you have logged in
      def default_params
        base = { :APIKey => API }
        #set_session
        if( session_id )
          base.merge!( :SessionID => session_id )
        end
        base
      end
      
      def set_session
        if( session_id.nil? )
          smug = Smug.new
          smug.auth_anonymously
          self.session_id = smug.session_id
        end
      end
    end
    
    attr_accessor :session_id
    def default_params
      self.class.session_id = self.session_id
      self.class.default_params
    end
  end
end