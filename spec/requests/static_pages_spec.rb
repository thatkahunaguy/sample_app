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
      expect(page).to have_title(full_title('About Us'))
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

    it { should have_content('Help') }
    it { should have_title(full_title('Help')) }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_content('About') }
    it { should have_title(full_title('About Us')) }
  end

  describe "Contact page" do
    before { visit contact_path }

    it { should have_content('Contact') }
    it { should have_title(full_title('Contact')) }
  end
end
