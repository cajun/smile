#
#  base.rb
#  smile
#
#  Created by Zac Kleinpeter on 2009-04-28.
#
module Smile
  class Base
    include Smile::Common
    attr_accessor :attributes

    class << self
      include Smile::Common

      def configure
        yield( session )
      end

      def clear_config!
        session.clear_config!
      end
    end

    def initialize( options={} )
      @attributes = OpenStruct.new( options )
    end

    def method_missing( name, *args )
      @attributes.send(name,*args)
    end
  end
end
