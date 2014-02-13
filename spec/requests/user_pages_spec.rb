require 'spec_helper'

describe "User pages" do

  subject { page }

  describe "signup page" do
    before { visit signup_path }

    it { should have_content('Sign up') }
    it { should have_title(full_title('Sign up')) }
  end

# not sure if there is a reason to separate signup from signup page in real life?
# tutorial did it since the controller & view for create (form submit) not done yet
  describe "signup" do
    before { visit signup_path } 
# user signup testing - useful tests   
    let(:submit) { "Create my account" }

    describe "with invalid information" do
      it "should not create a user" do
      # submit with no information/blank, User.count shouldn't change
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",         with: "Example User"
        fill_in "Email",        with: "user@example.com"
        fill_in "Password",     with: "foobar"
        fill_in "Confirmation", with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end

# ensure the user is signed in after signup
       describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: 'user@example.com') }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
        
# ensure that signout works      
        describe "followed by signout" do
          before { click_link "Sign out" }
          it { should have_link('Sign in') }
        end
      end


      
    end
  end



  describe "profile page" do
  # set a user variable using FactoryGirl Gem and spec/factories
    let(:user) { FactoryGirl.create(:user) }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end
end
