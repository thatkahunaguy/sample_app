class UsersController < ApplicationController
# the only hash restricts the before filter to the edit, index, and update
# functions - in this case it runs :signed_in_user before those
  before_action :signed_in_user, only: [:edit, :update, :index]
  # make sure the user is the correct one in addition to being signed in
  before_action :correct_user,   only: [:edit, :update]
  def show
    @user = User.find(params[:id])
  end

  def new
    @user = User.new
  end
  
  def create
    # this creates params hash which holds attributes
    @user = User.new(user_params)
    if @user.save
     # there is no create view so we want to sign_in & redirect to
     # the user profile just created
      sign_in @user
      flash[:success] = "Welcome to the Sample App!"
      redirect_to @user
    else
      render 'new'
    end
  end
  
  def index
    @users = User.all
  end
  
  def edit
  end

# update (CRUD) happens when patch - Rails automatically does patch when
# @user.new_record? is false and post(or create) when it's true
  def update   
    # note the use of user_params strong parameters to avoid mass assignment vulnerability
    if @user.update_attributes(user_params)
        flash[:success] = "Profile updated"
        redirect_to @user
    else
      render 'edit'
    end
  end

  private

# defines what parameters are permitted to be passed rather than initializing
# with the whole params(:user) hash which is a security risk.  A private method
    def user_params
      params.require(:user).permit(:name, :email, :password,
                                   :password_confirmation)
    end  

# Before filters - these occur before actions in the controller [before_action]
# signed_in? and current_user? were defined in the sessions helper
    def signed_in_user
      unless signed_in?
        store_location
        redirect_to signin_url, notice: "Please sign in."
      end
    end
# note that the @ user=... used to be the first part of every action, now it's been
# removed from edit and update and included as part of the before filter
    def correct_user
    # use the params hash to find the user by id
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

end
