require File.dirname(__FILE__) + '/test_helper'

class SmileTest < Test::Unit::TestCase
  def setup
    @smug = Smile::Smug.new
    @smug.auth_anonymously
  end
  
  def test_auth
    assert_not_nil( @smug.auth_anonymously )
  end
  
  def test_have_albums
    assert_nothing_raised(Exception) do
      assert_not_nil( @smug.albums( :nick_name => 'kleinpeter' ) )
    end
  end
  
  def test_have_photos
    assert_nothing_raised(Exception) do
      album = @smug.albums( :nick_name => 'kleinpeter' ).first
      assert_not_nil( album.photos )
    end
  end
  
  def test_photo_has_album
    assert_nothing_raised(Exception) do
      album = @smug.albums( :nick_name => 'kleinpeter' ).first
      photo = album.photos.first
      assert_equal( album.album_id, photo.album.album_id )
      assert_equal( album.key, photo.album.key )
    end
  end
  
  def test_photo_has_album_has_photo
    assert_nothing_raised(Exception) do
      album = @smug.albums( :nick_name => 'kleinpeter' ).first
      photo = album.photos.first
      alt_photo = photo.album.photos.first
      
      assert_equal( photo.image_id, alt_photo.image_id )
    end
  end
  
  # NOTE have to be logged in to test this one
  # def test_album_stats
  #   assert_nothing_raised(Exception) do
  #     album = @smug.albums( :nick_name => 'kleinpeter' ).first
  #     assert_not_nil( album.stats )
  #   end
  # end
  
  def test_photo_extras
    assert_nothing_raised(Exception) do
      album = @smug.albums( :nick_name => 'kleinpeter' ).first
      photo = album.photos.first
      
      assert_not_nil( photo.details )
      assert_not_nil( photo.info )
      assert_not_nil( photo.urls )
    end
  end
end
