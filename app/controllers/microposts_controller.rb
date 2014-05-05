class MicropostsController < ApplicationController
  before_action :signed_in_user

  def create
    # note use of strong params
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "New micropost created!"
      redirect_to root_url
    else
      render 'static_pages/home'
    end
  end


  def destroy
  end
  
private

# defines what parameters are permitted to be passed rather than initializing
# with the whole params(:user) hash which is a security risk.  A private method
    def micropost_params
      params.require(:micropost).permit(:content)
    end 
end