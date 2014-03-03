module SessionsHelper

  def sign_in(user)
    remember_token = User.new_remember_token
    cookies.permanent[:remember_token] = remember_token
    user.update_attribute(:remember_token, User.encrypt(remember_token))
    self.current_user = user
  end



# define a boolean for use in branching if a user is signed in or not
  def signed_in?
    !current_user.nil?
  end

# this is special Ruby syntax for function assignment.  It allows
# self.current_user = user to call the method below & assign a value to
# the instance variable @current_user
  def current_user=(user)
    @current_user = user
  end

# method to return the value of the current user (instance var @current_user
  def current_user
# encrypt the remember token so it can be used to lookup the user if needed
# it would be needed at a new page for example
    remember_token = User.encrypt(cookies[:remember_token])
# ||= is or equals meaning if current user exists(true) find_by doesn't execute
    @current_user ||= User.find_by(remember_token: remember_token)
  end

  def current_user?(user)
    user == current_user
  end
    
  def sign_out
# change the remember_token in the database in case the user cookie is stolen
    current_user.update_attribute(:remember_token,
                                  User.encrypt(User.new_remember_token))
# delete the cookie
    cookies.delete(:remember_token)
# update the current_user to nil
    self.current_user = nil
  end

# redirect to the page the user was trying to go to rather than the default if needed
  def redirect_back_or(default)
    redirect_to(session[:return_to] || default)
    session.delete(:return_to)
  end

# store the page the user was trying to get to
  def store_location
# only for get requests so we don't store post requests etc and get an error with a redirect
    session[:return_to] = request.url if request.get?
  end
  
end
