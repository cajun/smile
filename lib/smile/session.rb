module Smile
  class Session
    include Singleton
    API = 'HSoqGCJ8ilF42BeThMGDZqqqOgj1eXqN'

    attr_accessor :id, :api_key, :logger_on
    attr_reader :log

    def has_id?
      @id.nil?
    end

    def api_key
      @api_key || API
    end

    def logger
      if( logger_on? )
        @log ||= Logger.new( STDOUT )
        RestClient.log ||= @log  
        @log
      else
        @blank ||= Logger.new nil
        RestClient.log ||= @blank  
        @blank
      end
    end

    def logger_on?
      @logger_on
    end

    def clear_config!
      @api_key, @log, @logger_on = nil,nil,nil
    end
  end
end
