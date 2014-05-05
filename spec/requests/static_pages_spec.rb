require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

# this tells the Rspec code below the test is on page so we don't have
# to put expect(page).to everywhere as we did before
  subject { page }

# this shared examples is only used right no on Home as noted below
  shared_examples_for "all static pages" do
# using should rather than expect(page).to for a more compact version 
    it { should have_selector('h1', text: heading) }
    it { should have_title(full_title(page_title)) }
# test this link clicking
    it "should have the right links on the layout" do
      click_link "About"
# errors out if I use the it syntax - probably because it's nested and doesn't
# know which it I'm referring to, about or the calling page
      expect(page).to have_title(full_title('About Us'))
      click_link "Contact"
      expect(page).to have_title(full_title('Contact'))
      click_link "Help"
      expect(page).to have_title(full_title('Help'))
      click_link "Home"
      expect(page).to have_title(full_title(''))
      click_link "sample app"
      expect(page).to have_title(full_title(''))
      click_link "Sign up now!"
      expect(page).to have_title(full_title('Sign up'))
    end
  end





  
# this is an alternate way to perform the tests shown in help, about, contact
# using the shared_examples_for block above.  Since this didn't really make
# the code any more compact I didn't change help, about, contact so that I
# could retain both uses in the code.  As we add more tests to the code that
# are shared this will probably change
  describe "Home page" do
    # before each action below do whats in the brackets
    before { visit root_path }
    let(:heading)    { 'Sample App' }
    let(:page_title) { '' }

    it_should_behave_like "all static pages"
    it { should_not have_title('| Home') }
  end

  describe "Help page" do
    before { visit help_path }
    let(:heading)    { 'Help' }
    let(:page_title) { 'Help' }
    it_should_behave_like "all static pages"
    
# for signed in users it should display the feed    
    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:micropost, user: user, content: "Lorem ipsum")
        FactoryGirl.create(:micropost, user: user, content: "Dolor sit amet")
        visit signin_path
        sign_in user
        visit root_path
      end

      it "should render the user's feed" do
        user.feed.each do |item|
# the first hash sign is Capybara CSS syntax and hash{ is ruby string interpolation
          expect(page).to have_selector("li##{item.id}", text: item.content)
        end
      end
    
  end

  describe "About page" do
    before { visit about_path }
    let(:heading)    { 'About' }
    let(:page_title) { 'About' }
    it_should_behave_like "all static pages"
  end

  describe "Contact page" do
    before { visit contact_path }
    let(:heading)    { 'Contact Us' }
    let(:page_title) { 'Contact Us' }
    it_should_behave_like "all static pages"
  end
end
end
