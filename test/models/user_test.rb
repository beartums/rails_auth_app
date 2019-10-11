require 'test_helper'

class UserTest < ActiveSupport::TestCase
  
  def setup
    @user = User.new(name: "example", email: "e@b.com",
                    password: 'mypass', password_confirmation: 'mypass')
  end
  
  test "name should be bepresent" do
    @user.name = "   "
    assert_not @user.valid?
  end

  test "email should be be present" do
    @user.email = "   "
    assert_not @user.valid?
  end
  
  test "password should be present" do
    @user.password = "   "
    assert_not @user.valid?
  end 
  
  test "password should be at least 6 characters" do 
    @user.password = "a" * 6
    @user.password_confirmation = "a" * 6
    assert @user.valid?
    @user.password = "a" * 5
    @user.password_confirmation = "a" * 5
    assert_not @user.valid?
  end 
  
  
    
  test "name should not be too long" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end 
  test "email should not be too long" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end 
  
  test "email validation should reject invalid addresses" do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  
  test "email addresses should be unique" do
    duplicate_user = @user.dup
    #duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  
  test "email addresses should be saved as lower-case" do
    mixed_case_email = "Foo@ExAMPle.CoM"
    @user.email = mixed_case_email
    @user.save
    assert_equal mixed_case_email.downcase, @user.reload.email
  end
  
  test "microposts dhould be destroyed on delete" do
    @user.save
    @user.microposts.create!(content: "my content")
    assert_difference 'Micropost.count',-1 do
      @user.destroy
    end
  end 
  
  test "should follow and unfollow a user" do
    lana = users(:lana)
    michael  = users(:michael)
    assert_not lana.following?(michael)
    lana.follow(michael)
    assert lana.following?(michael)
    assert michael.followers.include?(lana)
    lana.unfollow(michael)
    assert_not lana.following?(michael)
    assert_not michael.followers.include?(lana)
  end
  
  test "feed should have the right posts" do
    michael = users(:michael)
    malory  = users(:malory)
    lana    = users(:lana)
    malory.follow(lana)
    # Posts from followed user
    lana.microposts.each do |post_following|
      assert malory.feed.include?(post_following)
    end
    # Posts from self
    michael.microposts.each do |post_self|
      assert michael.feed.include?(post_self)
    end
    # Posts from unfollowed user
    lana.microposts.each do |post_unfollowed|
      assert_not michael.feed.include?(post_unfollowed)
    end
  end


  # test "the truth" do
  #   assert true
  # end
end
