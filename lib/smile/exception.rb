module Smile 
  class Exception < StandardError
    def initialize( message =nil )
      Smile::Base.logger.error( message )
      super( message )
    end
  end

  exceptions = %w[ InvalidLogin ]

  exceptions.each { |ex| const_set( ex, Class.new(Smile::Exception) ) }
end
