module Smile
  class Json 
  
    class << self
      def parse( text )
        Smile::Base.logger.info( text )
        @result = JSON.parse(text) # This is the default JSON parse
        raise_exception! if has_error?
        @result  
      end

      def has_error?
        @result["stat"] == 'fail'
      end

      def error_message
        @result["message"] if has_error?
      end

      def raise_exception!
        raise Smile::Exception.new( error_message )
      end
    end
  end
end
