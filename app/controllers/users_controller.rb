class UsersController < ApplicationController

  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end
  
  def create
    @user = User.new(user_params)
    if @user.save
     # there is no create view so we want to redirect to the user profile just created
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end

  private

# defines what parameters are permitted to be passed rather than initializing
# with the whole params(:user) hash which is a security risk.  A private method
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end  
end
