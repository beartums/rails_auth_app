require 'test_helper'

class UsersControllerTest < ActionDispatch::IntegrationTest
  def setup
    @base_title = "Ruby on Rails Tutorial Sample App"
    @user = users(:lana)
    @other_user = users(:archer)
    @admin_user = users(:malory)
  end
  
  test "should get new" do
    get signup_path
    assert_response :success
    assert_select "title", full_title("Sign Up")
  end
  
  test "should redirect edit when not logged in" do
    get edit_user_path(@user)
    assert_not flash.empty?
    assert_redirected_to login_url
  end
  
  test "should redirect update when not logged in" do
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert_not flash.empty?
    assert_redirected_to login_url
  end 
  
  test "should redirect edit when editing wrong user" do
    log_in_as(@other_user)
    get edit_user_path(@user)
    assert flash.empty?
    assert_redirected_to root_url
  end 
  
  test "should redirect update of another user" do 
    log_in_as(@other_user)
    patch user_path(@user), params: { user: { name: @user.name,
                                              email: @user.email } }
    assert flash.empty?
    assert_redirected_to root_url
  end 
  
  test "should redirect from index if not logged in" do
    get users_path
    assert_redirected_to login_url
  end 
  
  test "should redirect delete if not admin or not logged in" do
    assert_no_difference 'User.count' do
      delete user_path(@user)
    end 
    assert_redirected_to login_url
    
    log_in_as(@user)
    assert_no_difference 'User.count' do 
      delete user_path(@other_user)
    end 
    assert_redirected_to root_url
    
    log_in_as(@admin_user)
    assert_difference 'User.count', -1 do
      delete user_path(@user)
    end 
    assert_redirected_to users_path
  end 
  
end
