require 'test_helper'

class MicropostsControllerTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:lana)
    @user2 = users(:archer)
    @micropost = microposts(:orange)
  end 
  
  test "should redirect create when not logged in" do
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "Lorem ipsum" } }
    end
    assert_redirected_to login_url
  end

  test "should redirect destroy when not logged in" do
    assert_no_difference 'Micropost.count' do
      delete micropost_path(@micropost)
    end
    assert_redirected_to login_url
  end

  test "should allow additon/deletion for logged_in user" do
    log_in_as @user
    assert_difference "Micropost.count",1 do 
      post microposts_path, params:
            { micropost: {user: @user, content: "test micropost"}}
    end 
    assert_redirected_to root_url
    # assert_difference "Micropost.count",-1 do 
    #   delete microposts_path(@micropost)
    # end 
  end
  
   test "should disallow deletion for different user" do
     log_in_as @user2

      assert_difference "Micropost.count",0 do 
        delete micropost_path(@micropost)
      end 
   end
  
end
