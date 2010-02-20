module Smile::ParamConverter
  module_function
  
  def convert( param, value=nil )
    key = nil
    key = case param.to_s.downcase.to_sym
      when :popular_category
        :popularCategory
      when :geo_all 
        :geoAll
      when :geo_keyword 
        :geoKeyword
      when :geo_search 
        :geoSearch
      when :geo_community
        :geoCommunity 
      when :open_search_keyword
        :openSearchKeyword
      when :user_keyword 
        :userkeyword
      when :nickname_recent 
        :nicknameRecent
      when :nickname_popular 
        :nicknamePopular
      when :user_comments 
        :userComments
      when :geo_user 
        :geoUser
      when :geo_album 
        :geoAlbum
      when :size
        value = value.titlecase
        :Size
      when :image_count
        :ImageCount
      when :data, :type, :description, :keywords, :geography, :position, :header,
        :clean, :filenames, :password, :public, :external, :protected, :watermarking,
        :larges, :originals, :comments, :share, :printable, :backprinting
        param.to_s.upcase.to_sym
      when :image_id
        :ImageID
      when :image_key
        :ImageKey
      when :image_count
        :ImageCount
      when :nickname, :nick_name
        :NickName
      when :category_id
        :CategoryID
      when :sub_categroy_id
        :SubCategoryID
      when :album_template_id
        :AlbumTemplateID
      when :highlight_id
        :HighlightID
      when :exif
        :EXIF
      when :square_thumbs
        :Square_Thumbs
      when :tempate_id
        :TemplateID
      when :sort_method
        :SortMethod
      when :sort_direction
        :SortDirection
      when :password_hint
        :PasswordHint
      when :word_searchable
        :WordSearchable
      when :smug_searchable
        :SmugSearchable
      when :watermark_id
        :WatermarkID
      when :hide_owner
        :HideOwner
      when :x_larges, :xlarges
        :XLarges
      when :x2_larges, :x2larges
        :X2Larges
      when :x3_larges, :x3larges
        :X3Larges
      when :can_rank
        :CanRank
      when :friend_edit
        :FriendEdit
      when :family_edit
        :FamilyEdit
      when :color_correction
        :ColorCorrection
      when :default_color
        :DefaultColor
      when :proof_days
        :ProofDays
      when :unsharp_amount
        :UnsharpAmount
      when :unsharp_radius
        :UnsharpRadius
      when :unsharp_sigma
        :UnsharpSigma
      when :community_id
        :CommunityID
      else
        key = param
    end
    
    [ key, value ]
  end
  
  def clean_hash_keys( hash_to_clean )
    cleaned_hash ={}
    hash_to_clean.each_pair do |key,value|
      cleaned_hash[convert( key ).first] = value
    end if( hash_to_clean )
    cleaned_hash
  end
  
end
