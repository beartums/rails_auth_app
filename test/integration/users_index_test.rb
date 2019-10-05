require 'test_helper'

class UsersIndexTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  
  def setup 
    @user = users(:lana)
    @admin_user = users(:malory)
  end 
  
  test "index including pagination for non-admin" do
    log_in_as(@user)
    get users_path
    assert_template "users/index"
    assert_select "div.pagination"
    User.order("name ASC").paginate(page: 1, per_page: 20).each do |user|
      assert_select 'a[href=?]', user_path(user), text: user.name
      assert_select "a[data-method='delete'][href=?]", user_path(user), count: 0
    end 
  end 
  
  test "delete when admin" do
    log_in_as(@admin_user)
    get users_path
    assert_template "users/index"
    User.order("name ASC").paginate(page: 1, per_page: 20).each do |user|
      if user != @admin_user
        assert_select "a[data-method='delete'][href=?]", 
                          user_path(user), text: "delete"
      else 
        assert_select "a[data-method='delete'][href=?]", 
                          user_path(user), text: "delete", count: 0
      end 
    end 
  end 
  
  test "no delete when not admin" do 
  end 

end
