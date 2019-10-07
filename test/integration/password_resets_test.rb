require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest

  def setup
    ActionMailer::Base.deliveries.clear
    @user = users(:lana)
  end 
  
  test "password resets" do
    get new_password_reset_path
    assert_template 'password_resets/new'
    assert_select 'input[name=?]', 'password_reset[email]'
    # invalid email
    post password_resets_path, params: { password_reset: {email: "foo@foo.foo"} }
    assert_not flash.empty?
    assert_template 'password_resets/new'
    assert_select 'div.alert-danger'
    
    # Valid Email
    post password_resets_path, params: { password_reset: {email: @user.email} }
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url


    # Password Reset Form
    user = assigns(:user)
    
    # Wrong Email
    get edit_password_reset_path(user.reset_token, email: "")
    assert_redirected_to root_url
    assert_not flash.empty?
    
    # Inactive User
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    assert_not flash.empty?
    user.toggle!(:activated)    
    
    # Right email, wrong token
    get edit_password_reset_path(User.new_token, email: user.email)
    assert_redirected_to root_url
    assert_not flash.empty?

    # Right email right token
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email

    # Invalid password & Confirmaiotion
    patch password_reset_path(user.reset_token), params: { email: user.email,
                    user: { password:              "foobaz",
                            password_confirmation: "barquux" } }  
    assert_template 'password_resets/edit'
    assert_select 'div#error_explanation'
    
    # Empty password
    patch password_reset_path(user.reset_token), params: { email: user.email,
                    user: { password:              "",
                            password_confirmation: "" } }  
    assert_template 'password_resets/edit'
    assert_select 'div#error_explanation'
    
    # valid password & confirmaiton
    patch password_reset_path(user.reset_token), params: { email: user.email,
                    user: { password:              "newpass",
                            password_confirmation: "newpass" } }  
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
    follow_redirect!
    assert_select 'div.alert-success'
    assert user.reload.reset_digest.nil?
    assert user.authenticated?(:password, "newpass")
    
    # used token does not display change page
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    assert_not flash.empty?
    follow_redirect!
    assert_select 'div.alert-danger'
    
    # used token rejects patch attempt
    log_out_user
    assert_not is_logged_in?
    patch password_reset_path(user.reset_token), params: { email: user.email,
                    user: { password:              "newpass2",
                            password_confirmation: "newpass2" } } 
    assert_redirected_to root_url
    assert_not_equal User.digest("newpass2"),  user.password_digest
    assert_not user.authenticated?(:password, "newpass2")
    assert user.authenticated?(:password, "newpass")
    follow_redirect!
    assert_select 'div.alert-danger'
  end 

end
