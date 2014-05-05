require 'spec_helper'


describe "Micropost pages" do

  subject {page}

  let(:user) { FactoryGirl.create(:user) }
  before do
    visit signin_path
    sign_in user
  end

  describe "micropost creation" do
    before {visit root_path }
      describe "with invalid infomation" do
        it "should not generate a micropost" do
          expect { click_button "Post" }.not_to change(Micropost, :count)
        end
        describe "it should have error messages" do
          before { click_button "Post" }
          it { should have_content("error") }
        end
      end
        
      describe "with valid information" do
        before { fill_in "micropost_content", with: "Waass uppp?" }
        it "should create a micropost" do
          expect { click_button "Post" }.to change(Micropost, :count).by(1)
        end
      end
    
  end
end
