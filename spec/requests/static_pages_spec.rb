require 'spec_helper'

describe "Static pages" do

  let(:base_title) { "Ruby on Rails Tutorial Sample App" }

# this tells the Rspec code below the test is on page so we don't have
# to put expect(page).to everywhere as we did before
  subject { page }

  describe "Home page" do
  
  # before each action below do whats in the brackets
    before { visit root_path }
    
  # using should rather than expect(page).to for a more compact version 
    it { should have_content('Sample App') }
  # right now this refers to a duplicate full_title helper in the support folder
    it { should have_title(full_title('')) }
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
