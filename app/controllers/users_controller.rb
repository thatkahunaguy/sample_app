class UsersController < ApplicationController
# these are before filters which run routine before certain actions
# the only hash restricts the before filter to the edit, index, and update
# functions - in this case it runs :signed_in_user before those
# this is authentication
  before_action :signed_in_user, only: [:edit, :update, :index, :destroy]
  
  # make sure the user is the correct one in addition to being signed in
  # this is authorization for user updates
  before_action :correct_user,   only: [:edit, :update]
  before_action :admin_user, only: [:destroy]
  
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
  # replace User.all with pagination - default is 30 objects per page
    @users = User.paginate(page: params[:page])
  end
  
  def edit
  end
  
  def destroy
    User.find(params[:id]).destroy
    flash[:success] = "User destroyed."
    redirect_to users_path
  end

# update (CRUD) happens when html issues patch - Rails automatically does patch when
# @user.new_record? is false and post(or create) when it's true
  def update   
    # note the use of user_params strong parameters to avoid mass assignment vulnerability
    # see below what attributes are allowed to be passed in the user_params definition
    if @user.update_attributes(user_params)
        flash[:success] = "Profile updated"
        redirect_to @user
    # rerender the edit page on unsuccessful update
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
# note that the @user=... used to be the first part of every action, now it's been
# removed from edit and update and included as part of the before filter
    def correct_user
    # use the params hash to find the user by id
      @user = User.find(params[:id])
      redirect_to(root_url) unless current_user?(@user)
    end

# intercept any destroy requests from users who aren't admins
    def admin_user
        redirect_to(root_url) unless current_user.admin?
    end

end
