require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  
  def setup 
    @user = users(:lana)
  end 
  
  test "reject edit with errors" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: {user: { name:  "aaaaaaa",
                                         email: "user@invalid.com",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    assert_template 'users/edit'
    assert_select 'ul.error-message-list li', count: 2
  end


  test "accept edit no errors" do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    name = "test name"
    email = "test@name.com"
    patch user_path(@user), params: { user: { name:  name,
                                        email: email,
                                        password:              "",
                                        password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal @user.name, name
    assert_equal @user.email, email

  end 
  
  test "successful edit with friendly forwarding" do
    get edit_user_path(@user)
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name  = "Foo Bar"
    email = "foo@bar.com"
    patch user_path(@user), params: { user: { name:  name,
                                              email: email,
                                              password:              "",
                                              password_confirmation: "" } }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_equal name,  @user.name
    assert_equal email, @user.email
  end

end
