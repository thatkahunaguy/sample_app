class SessionsController < ApplicationController

  def new
  end

def create
  user = User.find_by(email: params[:session][:email].downcase)
  if user && user.authenticate(params[:session][:password])
    # Sign the user in and redirect to the user's show page.
    flash[:success] = "Welcome Back!"
    redirect_to user
  else
    # Create an error message and re-render the signin form.
    flash[:error] = "Can't find that user"
    render "new"
  end
end

  def destroy
  end
  
end
