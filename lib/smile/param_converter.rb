module Smile::ParamConverter
  module_function
  
  def convert( param, value=nil )
    key = nil
    key = case param.to_s.downcase.to_sym
      when :popular_category, :geo_all, :geo_keyword,
        :geo_search, :geo_community, :open_search_keyword, :user_keyword,
        :nickname_recent, :nickname_popular, :user_comments, :geo_user,
        :geo_album
        first_letter_downcase( param.to_s.classify ).to_sym
      when :size 
        value = value.titlecase
        :Size
      when :data, :type, :description, :keywords, :geography, :position, :header,
        :clean, :filenames, :public, :external, :protected, :watermarking,
        :larges, :originals, :comments, :share, :printable, :backprinting
        param.to_s.upcase.to_sym
      when :image_id, :image_key, :image_count, :nick_name, :category_id,
        :sub_category_id, :album_key, :album_template_id, :highlight_id, :square_thumbs,
        :template_id, :sort_method, :sort_direction, :password_hint, :word_searchable,
        :smug_searchable, :watermark_id, :hide_owner, :x_larges, :x2_larges, :x3_larges,
        :can_rank, :friend_edit, :family_edit, :color_correction, :default_color, :proof_days,
        :unsharp_amount, :unsharp_radius, :unsharp_sigma, :community_id, :password, :email_address,
        :heavy
        param.to_s.classify.to_sym
      when :exif
        :EXIF
      when :api_key
        :APIKey
      when :session_id
        :SessionID
      when :album_id
        :AlbumID
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
 
  def first_letter_downcase( stuff )
    stuff.to_s.gsub( /^(\w)/, $1.downcase )
  end

end
