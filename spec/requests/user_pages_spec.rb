require 'spec_helper'

describe "User pages" do

  subject { page }

# verify the index has all user names
  describe "index" do
    let(:user) { FactoryGirl.create(:user) }
    before do     
      visit signin_path
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }
    
    describe "pagination" do

      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all)  { User.delete_all }
# make sure it has a pagination marker now that we paginate
      it { should have_selector('div.pagination') }

      it "should list each user" do
# Replace User.all.each do with paginate page 1 now that we paginate
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do

      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }
        before do
          visit signin_path
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end

  end

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
      describe "after submission" do
        before { click_button submit }

        it { should have_title('Sign up') }
        it { should have_content('error') }
        # could add more specific content checks here
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

# edit user profile tests
  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }
    before do
    # this isn't working as np sign_in method defined for Rspec & include SessionsHelper
    # didn't work
      visit signin_path
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit user") }
      it { should have_link('change', href: 'http://gravatar.com/emails') }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end
    
    describe "with valid information" do
      let(:new_name)  { "New Name" }
      let(:new_email) { "new@example.com" }
      before do
        fill_in "Name",             with: new_name
        fill_in "Email",            with: new_email
        fill_in "Password",         with: user.password
        fill_in "Confirm Password", with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      # check that the database actually updated
      specify { expect(user.reload.name).to  eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end
  end


  describe "profile page" do
  # set a user variable using FactoryGirl Gem and spec/factories
    let(:user) { FactoryGirl.create(:user) }
    # must use the bang ! here to ensure microposts are associated right away for test
    let!(:m1) { FactoryGirl.create(:micropost, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:micropost, user: user, content: "Bar") }
    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
    
    describe "microposts" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.microposts.count) }
    end
    
  end
end
