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
  it { should be_valid }

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

end
