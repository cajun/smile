class Smile::Photo < Smile::Base
  
  class << self
    def from_xml( xml, session_id )
      hash = Hash.from_xml( xml )["rsp"]
      hash["images"]["image"].map do |image|
        image.merge!( :image_id => image["id"] )
        a = Smile::Photo.new( image )
        a.session_id = session_id
        a
      end
    end
  end
end