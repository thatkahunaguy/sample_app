require 'spec_helper'

describe User do

  before { @user = User.new(name: "Example User", email: "user@example.com",
                password: "foobar", password_confirmation: "foobar") }

  subject { @user }

#these are the columns in the dbase we want to be able to CRUD
  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:remember_token) }
#password and its confirmation will only exist in memory, not the database
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
#methods it should respond to
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:microposts) }
  it { should respond_to(:feed) }

  it { should be_valid }
  it { should_not be_admin }

# test that admin boolean works for admin user
  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

#test that a validation fails when name isn't present
  describe "when name is not present" do
    before { @user.name = " " }
    it { should_not be_valid }
  end
  
#test that a validation fails when email isn't present
  describe "when email is not present" do
    before { @user.email = " " }
    it { should_not be_valid }
  end

#test that a validation fails when password isn't present
  describe "when password is not present" do
    before { @user.password = " ", @user.password_confirmation = " " }
    it { should_not be_valid }
  end

#test that a validation fails when name is too long
  describe "when name is too long (> 50 char)" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

#test email format validation
  describe "when email format is invalid" do
    it "should be invalid" do
    # %w makes an array in ruby
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com foo@bar..com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

#test email uniqueness validation by adding a dup email to the dbase
 describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      # upcase the email (should this really change case rather than upcase?)
      # to ensure that the uniqueness attribute is case sensitive
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

# test that mixed case is saved as lower case
  describe "email address with mixed case" do
    let(:mixed_case_email) { "Foo@ExAMPle.CoM" }

    it "should be saved as all lower-case" do
      @user.email = mixed_case_email
      @user.save
      expect(@user.reload.email).to eq mixed_case_email.downcase
    end
  end
  
#test for password mismatch
  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

#test authentication
describe "return value of authenticate method" do
  before { @user.save }
  let(:found_user) { User.find_by(email: @user.email) }

  describe "with valid password" do
    it { should eq found_user.authenticate(@user.password) }
  end

  describe "with invalid password" do
    let(:user_for_invalid_password) { found_user.authenticate("invalid") }

    it { should_not eq user_for_invalid_password }
    specify { expect(user_for_invalid_password).to be_false }
  end
end

# too short a password
describe "with a password that's too short" do
  before { @user.password = @user.password_confirmation = "a" * 5 }
  it { should be_invalid }
end

# ensure a non-blank remember_token is in place before saving
  describe "remember token" do
    before { @user.save }
    its(:remember_token) { should_not be_blank }
  end

# make sure microposts are associated and show in correct order
  describe "micropost associations" do
    before { @user.save }
# the ! below (a bang) forces immediate assignment to the variables
# otherwise a normal let variable only comes into existence when it is
# referenced in later code [accurate? this is how Hartl describes it]
    let!(:older_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.day.ago)
    end
    let!(:newer_micropost) do
      FactoryGirl.create(:micropost, user: @user, created_at: 1.hour.ago)
    end

    it "should have the right microposts in the right order" do
      # convert microposts to array and compare
      expect(@user.microposts.to_a).to eq [newer_micropost, older_micropost]
    end
    
    it "should destroy associated microposts" do
    # make a copy of the microposts before destroying the user
      microposts = @user.microposts.to_a
      @user.destroy
      # verify the microposts are there - what about the case where a user
      # had no microposts?  Since we've set the test with 2 not an issue here
      expect(microposts).not_to be_empty
      microposts.each do |micropost|
      # where is used instead of find as where returns an empty object rather than 
      # an exception
        expect(Micropost.where(id: micropost.id)).to be_empty
      end
    end
    
    describe "status" do
      let(:unfollowed_post) do
        FactoryGirl.create(:micropost, user: FactoryGirl.create(:user))
      end

      its(:feed) { should include(newer_micropost) }
      its(:feed) { should include(older_micropost) }
      its(:feed) { should_not include(unfollowed_post) }
    end
  end

end
