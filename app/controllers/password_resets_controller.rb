class PasswordResetsController < ApplicationController
  before_action :get_user, only: [:edit, :update]
  before_action :valid_user, only: [:edit, :update]
  before_action :check_expiration, only: [:edit, :update]
  
  def create
    @user = User.find_by(email: params[:password_reset][:email].downcase)
    if @user
      @user.create_reset_digest
      @user.send_reset_email
      flash[:info] = "Password Reset instructions sent"
      redirect_to root_url
    else
      flash.now[:danger] = "Email Address Not Found!"
      render "new"
    end 
  end 
  
  def new
  end

  def edit
    @email = @user.email
    @token = params[:id]
  end
  
  def update
    if params[:user][:password].empty?
      @user.errors.add(:password, "can't be empty")
      render 'edit'
    elsif @user.update(user_params)                     # Case (4)
      # Password token should be single-use
      @user.update_attribute(:reset_digest, nil)
      log_in @user
      flash[:success] = "Password has been reset."
      redirect_to @user
    else
      render 'edit'                                     # Case (2)
    end
  end
    
  
  private
  
 
    def user_params
      params.require(:user).permit(:password, :password_confirmation)
    end

    def get_user
      @user = User.find_by(email: params[:email])
    end 
    
    def valid_user

      unless (@user && @user.activated? &&
              @user.authenticated?(:reset, params[:id]))
        flash[:danger] = "Sorry, your password reset token is invalid"
        redirect_to root_url
      end
    end 
    
   def check_expiration
     if @user.password_reset_expired
       flash[:danger] = "password reset token is friggin' expired!"
       redirect_to new_password_reset_url
     end 
   end 
end
