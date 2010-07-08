# The Album class will fetch any public/private album hosted on SmugMug.
#
# the album objects will have the following fields on the response
#
# result
#
# standard response
# 
# 
# Album
#   album_id
#   album_key
#   title
#   category { id,  name }
#   subcategory { id, name }
#
# HEAVY RESPONSE ( DEFAULT )
#   
# Album
#   album_id
#   album_key
#   title
#   category { id,  name }
#   subcategory { id, name }
#   string description
#   string keywords
#   boolean geography (owner)
#   integer position
#   struct hightlight (owner) { id }
#   integer imagecount
#   string lastupdated
#   boolean header (owner, power & pro only)
#   boolean clean (owner)
#   boolean exif (owner)
#   boolean filenames (owner)
#   struct template (owner) { id }
#   string sortmethod (owner)
#   boolean sortdirection (owner)
#   string password (owner)
#   string passwordhint (owner)
#   boolean public (owner)
#   boolean worldsearchable (owner)
#   boolean smugsearchable (owner)
#   boolean external (owner)
#   boolean protected (owner, power & pro only)
#   boolean watermarking (owner, pro only)
#   struct watermark (owner, pro only) { id }
#   boolean hideowner (owner)
#   boolean larges (owner, pro only)
#   boolean xlarges (owner, pro only)
#   boolean x2larges (owner)
#   boolean x3larges (owner)
#   boolean originals (owner)
#   boolean canrank (owner)
#   boolean friendedit (owner)
#   boolean familyedit (owner)
#   boolean comments (owner)
#   boolean share (owner)
#   boolean printable (owner)
#   int colorcorrection (owner)
#   integer proofdays (owner, pro only)
#   string backprinting (owner, pro only)
#   float unsharpamount (owner, power & pro only)
#   float unsharpradius (owner, power & pro only)
#   float unsharpthreshold (owner, power & pro only)
#   float unsharpsigma (owner, power & pro only)
#   struct community (owner) id
#   
#  @author Zac Kleinpeter 
#  @date 2009-04-28.
class Smile::Album < Smile::Base

  class << self
    # Converts the json results from the web service into 
    # Album object to use
    def from_json( json )
      json["albums"].map do |album_upper|
        album = upper_hash_to_lower_hash( album_upper )
        album.merge!( :album_id => album["id"] )
        album.merge!( :album_key => album["key"] )

        Smile::Album.new( album )
      end
    end
    
    # This will pull a single album from the smugmug.
    # The Site ID is auto passed if you are logged in.
    #
    # @param [Hash] :options yes this is the has you will put stuff
    # @param options [String] :album_id This is the ID of the album you want to find
    # @param options [String] :album_key This is the KEY for the albums
    # @param options [optional, String] :password password for the albums
    # @param options [optional, String] :site_password password for the site
    def find( options={} )
      json = web_method_call( { :method => 'smugmug.albums.getInfo' }, options )
      
      album = json['album'] 
      album.merge!( :album_id => album["id"] )
      album.merge!( :album_key => album["key"] )
      
      Smile::Album.new( album )
    end
    
    # Update the album from the following params
    #
    # @param [String] title What you want to call it
    # @param [optional, Hash] options wow it's a hash
    #
    # Essentials
    # @option options [Fixnum] :category_id it is what it is
    # @option options [optional, Fixnum] :sub_category_id ( 0 ) guess what this is
    # @option options [optional, String] :description what am i looking at
    # @option options [optional, String] :keywords space seperated or comman don't know
    # @option options [optional, Fixnum] :album_template_id ( 1 ) yup
    # @option options [optional, Boolean] :geography ( 0 ) huh?
    # @option options [optional, Fixnum] :highlight_id you guess is as good as mine
    # @option options [optional, Fixnum] :position I'm just the dev
    #
    # Look & Feel
    # @option options [optional, Boolean] :header ( 0 ) yup
    # @option options [optional, Boolean] :clean ( 0 ) @see http://smugmug.com
    # @option options [optional, Boolean] :exif ( 1 ) @see http://smugmug.com
    # @option options [optional, Boolean] :filenames ( 0 ) show file names
    # @option options [optional, Boolean] :square_thumbs ( 1 ) user square ones
    # @option options [optional, Fixnum] :template_id ( 0 ) 0:Viewer Choice 3:SmugMug 4:Traditional 7:All Thumbs 8:Slideshow 9:Journal 10:SmugMug Small 11:Filmstrip
    # @option options [optional, String] :sort_method ( 'Position' ) %w( Position Caption FileName Date DateTime DateTimeOriginal )
    # @option options [optional, 1 or 0] :sort_direction 0: Ascending (1-99, A-Z, 1980-2004, etc) 1: Descending (99-1, Z-A, 2004-1980, etc)
    #
    # Security & Privacy
    # @option options [optional, String] :password want one?
    # @option options [optional, String] :password_hint need one?
    # @option options [optional, Boolean] :public ( 1 ) is it?
    # @option options [optional, Boolean] :world_searchable ( 1 ) can i?
    # @option options [optional, Boolean] :smug_searchable ( 1 ) please?
    # @option options [optional, Boolean] :external ( 1 ) let everyone know
    # @option options [optional, Boolean] :protected ( 0 ) MINE!!!
    # @option options [optional, Boolean] :watermarking ( 0 ) kinda cool
    # @option options [optional, Fixnum] :watermark_id ( 0 ) which one
    # @option options [optional, Boolean] :hide_owner ( 0 ) you can't see me
    # @option options [optional, Boolean] :larges ( 1 ) show bigens
    # @option options [optional, Boolean] :x_larges ( 1 ) show X bigens
    # @option options [optional, Boolean] :x2_larges ( 1 ) show XX bigens
    # @option options [optional, Boolean] :x3_larges ( 1 ) show XXX bigens
    # @option options [optional, Boolean] :originals ( 1 ) show what i uploaded
    #
    # Social
    # @option options [optional, Boolean] :can_rank ( 1 ) well...yesss
    # @option options [optional, Boolean] :friend_edit ( 0 ) yeah i have friends!!!
    # @option options [optional, Boolean] :family_edit ( 0 ) go ahead ma
    # @option options [optional, Boolean] :comments ( 1 ) I just wanted to say....
    # @option options [optional, Boolean] :share ( 1 ) here you go
    #
    # Printing & Sales
    # @option options [optional, Boolean] :printable ( 1 ) yes
    # @option options [optional, Fixnum] :color_correction ( 2 ) 0:No 1:Yes 2:Injerit
    # @option options [optional, Boolean] :default_color ( 0 ) ( pro only deprecated ) 1:Auto 0: True
    # @option options [optional, Fixnum] :proof_days ( 0 ) yep ( pro only )
    # @option options [optional, String] :back_printing what you want to see behind you
    #
    # Photo Sharpening
    # @option options [optional, Float] :unsharp_amount ( 0.200 ) numbers
    # @option options [optional, Float] :unsharp_radius ( 1.000 ) more numbers
    # @option options [optional, Float] :unsharp_threshold ( 0.050 ) I'm a dev what does this mean?
    # @option options [optional, Float] :unsharp_sigma ( 1.000 ) and more numbers
    #
    # Community
    # @option options [optional, Fixnum] :community_id ( 0 ) join the group
    def create( title, options )
      json = web_method_call( { :method => 'smugmug.albums.create', :album_id => album_id })

      self.from_json( json )
    end
  end

  # Update the album from the following params
  #
  # @param [optional, Hash] options wow it's a hash
  #
  # Essentials
  # @option options [optional, String] :title the title maybe?
  # @option options [optional, Fixnum] :category_id it is what it is
  # @option options [optional, Fixnum] :sub_category_id guess what this is
  # @option options [optional, String] :description what am i looking at
  # @option options [optional, String] :keywords space seperated or comman don't know
  # @option options [optional, Fixnum] :album_template_id yup
  # @option options [optional, Boolean] :geography huh?
  # @option options [optional, Fixnum] :highlight_id you guess is as good as mine
  # @option options [optional, Fixnum] :position I'm just the dev
  #
  # Look & Feel
  # @option options [optional, Boolean] :header yup
  # @option options [optional, Boolean] :clean @see http://smugmug.com
  # @option options [optional, Boolean] :exif @see http://smugmug.com
  # @option options [optional, Boolean] :filenames show file names
  # @option options [optional, Boolean] :square_thumbs user square ones
  # @option options [optional, Fixnum] :template_id 0:Viewer Choice 3:SmugMug 4:Traditional 7:All Thumbs 8:Slideshow 9:Journal 10:SmugMug Small 11:Filmstrip
  # @option options [optional, String] :sort_method %w( Position Caption FileName Date DateTime DateTimeOriginal )
  # @option options [optional, 1 or 0] :sort_direction 0: Ascending (1-99, A-Z, 1980-2004, etc) 1: Descending (99-1, Z-A, 2004-1980, etc)
  #
  # Security & Privacy
  # @option options [optional, String] :password want one?
  # @option options [optional, String] :password_hint need one?
  # @option options [optional, Boolean] :public is it?
  # @option options [optional, Boolean] :world_searchable can i?
  # @option options [optional, Boolean] :smug_searchable please?
  # @option options [optional, Boolean] :external let everyone know
  # @option options [optional, Boolean] :protected MINE!!!
  # @option options [optional, Boolean] :watermarking kinda cool
  # @option options [optional, Fixnum] :watermark_id which one
  # @option options [optional, Boolean] :hide_owner you can't see me
  # @option options [optional, Boolean] :larges show bigens
  # @option options [optional, Boolean] :x_larges show X bigens
  # @option options [optional, Boolean] :x2_larges show XX bigens
  # @option options [optional, Boolean] :x3_larges show XXX bigens
  # @option options [optional, Boolean] :originals show what i uploaded
  #
  # Social
  # @option options [optional, Boolean] :can_rank well...yesss
  # @option options [optional, Boolean] :friend_edit yeah i have friends!!!
  # @option options [optional, Boolean] :family_edit go ahead ma
  # @option options [optional, Boolean] :comments I just wanted to say....
  # @option options [optional, Boolean] :share here you go
  #
  # Printing & Sales
  # @option options [optional, Boolean] :printable yes
  # @option options [optional, Fixnum] :color_correction 0:No 1:Yes 2:Injerit
  # @option options [optional, Boolean] :default_color ( pro only deprecated ) 1:Auto 0: True
  # @option options [optional, Fixnum] :proof_days yep ( pro only )
  # @option options [optional, String] :back_printing what you want to see behind you
  #
  # Photo Sharpening
  # @option options [optional, Float] :unsharp_amount numbers
  # @option options [optional, Float] :unsharp_radius more numbers
  # @option options [optional, Float] :unsharp_threshold I'm a dev what does this mean?
  # @option options [optional, Float] :unsharp_sigma and more numbers
  #
  # Community
  # @option options [optional, Fixnum] :community_id join the group
  def update( options )
    json = web_method_call( { :method => 'smugmug.albums.changeSettings', :album_id => album_id } )

    true
  end
  
  # This will pull all the photos for a given album
  #
  # @param [optional, Hash] options wow it's a hash
  # 
  # @option options [optional, boolean] :heavy ( true ) default is true
  # @option options [optional, string] :password password for the pics
  # @option options [optional, string] :site_password access via site password
  def photos( options=nil )
    json = web_method_call(
        {
          :method => 'smugmug.images.get',
          :album_id => album_id,
          :album_key => key,
          :heavy => 1
        },
        options
    )
    Smile::Photo.from_json( json )
  end
  
  # Pull stats for an Album for a given Month and Year
  #
  # @param [optional, Hash] options wow it's a hash
  # @option options [optional, Fixnum] :month (Date.today.month) month field
  # @option options [optional, Fixnum] :year (Date.today.year) the year and stuff
  # @option options [optional, 1 or 0] :heavy more details
  def stats( options =nil )
    json = web_method_call( 
      { :method => 'smugmug.albums.getStats', :album_id => album_id, :month => Date.today.month, :year => Date.today.year },
      options
    )

    OpenStruct.new( json['album'] )
  end
  
  # Add an image or vid to the existing album
  # 
  # @param [String] image path to image
  # @param [options,Hash] options Extra params that are accepted 
  # @option options [optional, String] :caption For multi-line captions, use a carriage return between lines
  # @option options [optional, String] :keywords Sets the Keywords on the image
  # @option options [optional, Decimal] :latitude Sets the Latitude of the image (in the form D.d, such as 37.430096)
  # @option options [optional, Decimal] :longitude Sets the Longitude of the image (in the form D.d, such as -122.152269)
  # @option options [optional, Decimal] :altitude Sets the Altitude of the image (in meters)
  def add( image, options={} )
    if( File.exists?( image ) )
      options = Smile::ParamConverter.clean_hash_keys( options )
      json = RestClient.put( UPLOAD + "/#{image}", File.read( image ),
        :content_length => File.size( image ),
        :content_md5 => MD5.hexdigest( File.read( image ) ),
        :x_smug_sessionid => self.session.id,
        :x_smug_version => VERSION,
        :x_smug_responseType => "Smile::Json",
        :x_smug_albumid => album_id,
        :x_smug_filename => File.basename( image ),
        :x_smug_caption => options[:caption],
        :x_smug_keywords => options[:keywords],
        :x_smug_latitude => options[:latitude],
        :x_smug_longitude => options[:longitude],
        :x_smug_altitude => options[:altitude] ).body
      
      image = Smile::Json.parse( json )
      if( image && image["image"] && image["image"]["id"] )
        Smile::Photo.find( :image_id => image["image"]["id"] )
      else
        raise Smile::Exception.new( "Failed to upload #{image}" )
      end
    else
      raise Smile::Exception.new( "Cannot find file #{image}." )
    end
  end
  
  # Want to get rid of that album?  Call this guy and see what gets removed!
  def delete!
    json = web_method_call( { :method => 'smugmug.albums.delete', :album_id => album_id })

    nil
  end
  
  # This method will re-sort all the photos inside of the album specified by album_id.
  #
  # @option options [String] :by valid values: FileName, Caption, DateTime
  # @option options [String] :direction valid values: ASC, DESC
  def resort!( options =nil )
    json = web_method_call( { :method => 'smugmug.albums.reSort', :album_id => album_id }, options)

    nil
  end
  
  def reload!
    @attributes = Smile::Album.find( { :album_id => album_id } ).attributes
    self
  end

  def category
    @attributes['category']
  end

  def subcategory
    ['subcategory']
  end
end
