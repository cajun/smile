module Smile
  class Session
    include Singleton
    attr_accessor :id

    def has_id?
      @id.nil?
    end
  end
end
