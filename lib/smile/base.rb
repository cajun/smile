module Smile
  class Base < OpenStruct
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
  end
end