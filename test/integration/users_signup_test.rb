require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
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

  end 
  test "user posted if no error" do
    assert_difference 'User.count', 1 do
      post users_path, params: { user: { name:  "my test name",
                                         email: "user@invalid.com",
                                         password:              "foobar",
                                         password_confirmation: "foobar" } }
    end
    assert_not flash.nil?
    follow_redirect!
    assert_template 'users/show'
    #assert flash.nil?
    assert_select "div.flash", count: 1
    assert is_logged_in?

  end 
end
