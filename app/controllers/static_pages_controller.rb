class StaticPagesController < ApplicationController
  def home
    if signed_in?
      @micropost = current_user.microposts.build
      @feed_items = current_user.feed.paginate(page: params[:page])
    end
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
