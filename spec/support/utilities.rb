
# this replaces having a duplicate full_title method in this file
include ApplicationHelper

# helpers and matching to make Rspec more succinct

    def sign_in(user, options={})
      if options[:no_capybara]
        # Sign in when not using Capybara.
        remember_token = User.new_remember_token
        cookies[:remember_token] = remember_token
        user.update_attribute(:remember_token, User.encrypt(remember_token))
      else
      # upcase the email to ensure the ability to find in the database isn't case sensitive
        fill_in "Email",    with: user.email.upcase
        fill_in "Password", with: user.password
        click_button "Sign in"
      end
    end