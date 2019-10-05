require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup
    @user = users(:lana)
  end 
  
  test "layout links" do
    get root_path
    assert_template "static_pages/home"
    assert_select "a[href=?]", home_path, count: 1
    assert_select "a[href=?]", root_path, count: 1
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path
    assert_select "a[href=?]", users_path, count: 0
    get contact_path
    assert_select "title", full_title("Contact")
  end 
  
  test "Layout links, logged in" do
    log_in_as(@user)
    get root_path
    assert_select "a[href=?]", users_path
  end 
  
end
