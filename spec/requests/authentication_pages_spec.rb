require 'spec_helper'

describe "Authentication" do

  subject { page }

  describe "signin page" do
    before { visit signin_path }

    it { should have_content('Sign in') }
    it { should have_title('Sign in') }
  end
  
   describe "signin" do
    before { visit signin_path }

    describe "with invalid information" do
      before { click_button "Sign in" }

      it { should have_title('Sign in') }
      it { should have_selector('div.alert.alert-error') }
      
      describe "after visiting another page" do
        before { click_link "Home" }
        it { should_not have_selector('div.alert.alert-error') }
      end
      
    end
    
      describe "with valid information" do
        let(:user) { FactoryGirl.create(:user) }
        
        
        # why does sign_in not work when I had it in spec_helper but does from support/utilities?
        before { sign_in user }

        it { should have_title(user.name) }
        it { should have_link('Users',       href: users_path) }
        it { should have_link('Profile',     href: user_path(user)) }
        it { should have_link('Settings',    href: edit_user_path(user)) }
        it { should have_link('Sign out',    href: signout_path) }
        it { should_not have_link('Sign in', href: signin_path) }
      
      end

    end
  
    describe "authorization" do

        describe "for non-signed-in users" do
          let(:user) { FactoryGirl.create(:user) }
          describe "when attempting to visit a protected page" do
            before do
              visit edit_user_path(user)
              fill_in "Email",    with: user.email
              fill_in "Password", with: user.password
              click_button "Sign in"
            end

            describe "after signing in" do

              it "should render the desired protected page" do
                expect(page).to have_title('Edit user')
              end
            end
          end
          describe "in the Users controller" do

            describe "visiting the edit page" do
              before { visit edit_user_path(user) }
              it { should have_title('Sign in') }
            end

            describe "submitting to the update action" do
              # this is issuing a patch request directly rather than using Capybara visit 
              # because to get to the update action you need to visit edit which shouldn't
              # be allowed for a user not signed in - so to properly test both edit and update
              # we have to directly issue a patch request to test update
              before { patch user_path(user) }
              specify { expect(response).to redirect_to(signin_path) }
            end
            # verify the index can't be visited when not signed in
            describe "visiting the user index" do
              before { visit users_path }
              it { should have_title('Sign in') }
            end     
          end 
        end
        
        describe "as wrong user" do
          let(:user) { FactoryGirl.create(:user) }
          # this is an example of a factory with an option - instead of the default email we specify one
          let(:wrong_user) { FactoryGirl.create(:user, email: "wrong@example.com") }
          # not using Capybara because we have to issue direct get and patches to test correctly here
          before { sign_in user, no_capybara: true }

          describe "submitting a GET request to the Users#edit action" do
          # try to edit the wrong user
            before { get edit_user_path(wrong_user) }
            # it shouldn't redirect to edit, it should redirect to root because u don't try to edit other users
            specify { expect(response.body).not_to match(full_title('Edit user')) }
            specify { expect(response).to redirect_to(root_url) }
          end

          describe "submitting a PATCH request to the Users#update action" do
          # try to update the wrong user
            before { patch user_path(wrong_user) }
            specify { expect(response).to redirect_to(root_url) }
          end
        end
    end
end
