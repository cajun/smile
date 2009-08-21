module Smile::ParamConverter
  module_function
  
  def convert( param, value=nil )
    key = nil
    case param.to_s.downcase.to_sym
      when :popular_category
        key = :popularCategory
      when :geo_all 
        key = :geoAll
      when :geo_keyword 
        key = :geoKeyword
      when :geo_search 
        key = :geoSearch
      when :geo_community
        key = :geoCommunity 
      when :open_search_keyword
        key = :openSearchKeyword
      when :user_keyword 
        key = :userkeyword
      when :nickname_recent 
        key = :nicknameRecent
      when :nickname_popular 
        key = :nicknamePopular
      when :user_comments 
        key = :userComments
      when :geo_user 
        key = :geoUser
      when :geo_album 
        key = :geoAlbum
      when :size
        key = :Size
        value = value.titlecase
      when :image_count
        key = :ImageCount
      when :data
        key = :Data
      when :type
        key = :Type
      when :image_id
        key = :ImageID
      when :image_key
        key = :ImageKey
      when :image_count
        key = :ImageCount
      when :nickname, :nick_name
        key = :NickName
      else
        key = param
    end
    
    [ key, value ]
  end
  
  def clean_hash_keys( hash_to_clean )
    cleaned_hash ={}
    hash_to_clean.each_pair do |key,value|
      cleaned_hash[convert( key ).first] = value
    end
    cleaned_hash
  end
  
end