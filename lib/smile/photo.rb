# 
#  photo.rb
#  smile
#  
#  Created by Zac Kleinpeter on 2009-04-28.
class Smile::Photo < Smile::Base
  
  class << self
    # Convert the given xml into photo objects to play with
    def from_json( json )
      logger.info( json )
      json["images"].map do |image_upper|
        image = upper_hash_to_lower_hash( image_upper )
        image.merge!( :image_id => image["id"] )
        image.merge!( :album_key => image["album"]["key"] )
        image.merge!( :album_id => image["album"]["id"] )
        image.delete( 'album' )

        Smile::Photo.new( image )
      end
    end
    
    # This will pull a single image from the smugmug
    #
    # @param [options,Hash] options the hash of options that you have heard about so much in ruby
    # @option options [int] :image_id The id of the image you want to find
    # @option options [optional, String] :password The id of the image you want to find
    # @option options [optional, String] :site_password password word for the site
    # @option options [optional, String] :image_key image key maybe?
    def find( options={} )
      image = web_method_call(
          { :method => 'smugmug.images.getInfo' },
          options
      )
      
      image = image['image']
      logger.info( image )

      image.merge!( :image_id => image["id"] )
      image.merge!( :album_key => image["album"]["key"] )
      image.merge!( :album_id => image["album"]["id"] )
      image.delete( 'album' )
      
      Smile::Photo.new( image )
    end
  end
  
  # This method will return camera and photograph details about the image specified by ImageID.
  # The Album must be owned by the Session holder, or else be Public (if password-protected, a
  # Password must be provided), to return results. Otherwise, an "invalid user" faultCode will
  # result. Additionally, the album owner must have specified that EXIF data is allowed. Note that
  # many photos have no EXIF data, so an empty or partially returned result is very normal.# 
  #
  # Arguments:* 
  # 
  # Result:* struct "Image" [some, none, or all may be returned]
  #   int "id"
  #   String "DateTime"
  #   String "DateTimeOriginal"
  #   String "DateTimeDigitized"
  #   String "Make"
  #   String "Model"
  #   String "ExposureTime"
  #   String "Aperture"
  #   int "ISO"
  #   String "FocalLength"
  #   int "FocalLengthIn35mmFilm"
  #   String "CCDWidth"
  #   String "CompressedBitsPerPixel"
  #   int "Flash"
  #   int "Metering"
  #   int "ExposureProgram"
  #   String "ExposureBiasValue"
  #   int "ExposureMode"
  #   int "LightSource"
  #   int "WhiteBalance"
  #   String "DigitalZoomRatio"
  #   int "Contrast"
  #   int "Saturation"
  #   int "Sharpness"
  #   String "SubjectDistance"
  #   int "SubjectDistanceRange"
  #   int "SensingMethod"
  #   String "ColorSpace"
  #   String "Brightness"
  #
  # @param [options,Hash] options ruby and hashes are like.......
  # @option options [String] :password a password field
  # @option options [String] :site_password site password field
  def details( options =nil )
    image = web_method_call(
      { :method => "smugmug.images.getEXIF", :ImageID => self.image_id, :ImageKey => self.key },
      options
    )
    
    image.merge!( :image_id => image["id"] )
    
    OpenStruct.new( image )
  end
  
  # This method will return details about the image specified by ImageID. The Album must be owned
  # by the Session holder, or else be Public (if password-protected, a Password must be provided),
  # to return results.. Otherwise, an "invalid user" faultCode will result. Additionally, some
  # fields are only returned to the Album owner.
  # 
  # Arguments:
  # 
  # String Password optional
  # String SitePassword optional
  #
  # Result:* struct "Image"
  # 
  # int "id"
  # String "Caption"
  # int "Position"
  # int "Serial"
  # int "Size"
  # int "Width"
  # int "Height"
  # String "LastUpdated"
  # String "FileName" owner only
  # String "MD5Sum" owner only
  # String "Watermark" owner only
  # Boolean "Hidden" owner only
  # String "Format"  owner only
  # String "Keywords" 
  # String "Date" owner only
  # String "AlbumURL"
  # String "TinyURL"
  # String "ThumbURL"
  # String "SmallURL"
  # String "MediumURL"
  # String "LargeURL" (if available)
  # String "XLargeURL" (if available)
  # String "X2LargeURL" (if available)
  # String "X3LargeURL" (if available)
  # String "OriginalURL" (if available)
  # struct "Album"
  # integer "id"
  # String "Key"
  def info( options =nil )
    image = web_method_call(
      { :method => "smugmug.images.getInfo", :ImageID => self.image_id, :ImageKey => self.key },
      options
    )
      
    image.merge!( :image_id => image["id"] )
    
    OpenStruct.new( image )  
  end
  
  # This method will return all the URLs for the various sizes of the image specified by
  # ImageID. The Album must be owned by the Session holder, or else be Public (if
  # password-protected, a Password must be provided), to return results. Otherwise, an "invalid
  # user" faultCode will result. Additionally, obvious restrictions on Originals and Larges
  # apply if so set by the owner. They will return as empty strings for those URLs if they're
  # unavailable.
  # 
  # Arguments:*
  # 
  # int TemplateID
  # optional, specifies which Style to build the AlbumURL with. Default: 3
  #   Possible values:
  #     Elegant: 3
  #     Traditional: 4
  #     All Thumbs: 7
  #     Slideshow: 8
  #     Journal: 9
  # String Password optional
  # String SitePassword optional
  #
  # Result:* struct
  # 
  # String "AlbumURL"
  # String "TinyURL"
  # String "ThumbURL"
  # String "SmallURL"
  # String "MediumURL"
  # String "LargeURL" (if available)
  # String "XLargeURL" (if available)
  # String "X2LargeURL" (if available)
  # String "X3LargeURL" (if available)
  # String "OriginalURL" (if available)
  def urls( options =nil )
    image = web_method_call(
      { :method => "smugmug.images.getURLs", :ImageID => self.image_id, :ImageKey => self.key },
      options
    )
      
    image.merge!( :image_id => image["id"] )
    
    OpenStruct.new( image )  
  end
  
  def album
    @album ||= Smile::Album.find( :AlbumID => self.album_id, :AlbumKey => self.album_key )
  end

  def reload!
    @attributes = Smile::Photo.find( { :ImageID => self.image_id, :ImageKey => self.key } ).attributes
    self
  end

  def encode64( size = :smallurl )
    url = @attributes.send( size )
    [open(url){ |io| io.read }].pack('m')
  end
end
