class ApplicationController < ActionController::Base
  include SessionsHelper
  
      
    def logged_in_user
      unless logged_in?
        store_location
        flash[:danger] = "Please Log In."
        redirect_to login_url
      end 
    end 
    
    def correct_user
      @user = User.find(params[:id])
      unless current_user?(@user)
        redirect_to root_url
      end 
    end 
    
end
