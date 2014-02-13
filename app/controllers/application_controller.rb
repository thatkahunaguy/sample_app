class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  
  # Sign in methods/module are included in Sessions but
  # need to be used in other controllers
  include SessionsHelper
  
end
