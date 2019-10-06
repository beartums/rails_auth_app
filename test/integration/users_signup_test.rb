require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  def setup
    ActionMailer::Base.deliveries.clear
  end 

  test "signup page renders" do
    get signup_path
    assert_template 'users/new'
  end
  
  test "user not posted with error" do
    assert_no_difference 'User.count' do
      post users_path, params: { user: { name:  "aaaaaaa",
                                         email: "user@invalid.com",
                                         password:              "foo",
                                         password_confirmation: "bar" } }
    end
    assert_select 'ul.error-message-list li', count: 2
    assert_select "div.field_with_errors"
  end 
  
  test "user posted if no error, and account acitvation" do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "my test name",
                                         email: "user@example.com",
                                         password:              "foobar",
                                         password_confirmation: "foobar" } }
    end
    assert_equal 1, ActionMailer::Base.deliveries.size
    user = assigns(:user)
    assert_not user.activated?
    #try to log in pre-activation
    log_in_as user
    assert_not is_logged_in?
    
    # invalid activation token
    get edit_account_activation_path("invalid", email: user.email)
    assert_not is_logged_in?
    # valid token, wrong email
    get edit_account_activation_path(user.activation_token, email: "foo@bar.com")
    assert_not is_logged_in?
    #valid token, valid activation
    get edit_account_activation_path(user.activation_token, email: user.email)
    assert user.reload.activated?
    follow_redirect!
    assert_template 'users/show'
    assert is_logged_in?
    
    # can't activate twice



  end 
end
