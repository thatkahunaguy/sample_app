class StaticPagesController < ApplicationController
  def home
  # need an instance variable to build the micropost form when logged in on home
  # only because that's where we decided to have the form reside
    @micropost = current_user.microposts.build if signed_in?
  end

  def help
  end
  
  def about
  end
  
  def contact
  end
  
  # This is just a placeholder allowing the rails form for the user model entry 1
  def order
    @user = User.first
  end
  
end
