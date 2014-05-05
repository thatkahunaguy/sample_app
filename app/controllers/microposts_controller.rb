class MicropostsController < ApplicationController
  before_action :signed_in_user
  before_action :correct_user,   only: [:destroy]

  def create
    # note use of strong params
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "New micropost created!"
      redirect_to root_url
    else
    # home needs instance variable feed items so duplicate from static controller
      @feed_items = current_user.feed.paginate(page: params[:page])
      render 'static_pages/home'
    end
  end


  def destroy
  
    @micropost.destroy
    flash[:success] = "Micropost destroyed."
    redirect_to root_url
  end
  
private

# defines what parameters are permitted to be passed rather than initializing
# with the whole params(:user) hash which is a security risk.  A private method
    def micropost_params
      params.require(:micropost).permit(:content)
    end 
    
    def correct_user
    # note that looking up through the current user association is more secure
    # than the alternative of directly looking up by Micropost.find_by like we did 4user
      @micropost = current_user.microposts.find_by(id: params[:id])
      redirect_to root_url if @micropost.nil?
    end
end