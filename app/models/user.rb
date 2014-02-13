class User < ActiveRecord::Base

# validate presence of name - note the code below is the same as
# validates(:name, {presence: true})  - parens optional and {} opt on hash last arg
  validates :name, presence: true, length: {maximum: 50}
  
# checking for valid email uses a regular expression (regex) to define format
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            # rails infers true for uniqueness since the case_sensitive flag is set
                uniqueness: { case_sensitive: false }
                
# ensure email is lowercase before saving to database to ensure dbase uniqueness
  before_save { self.email = email.downcase }

# callback to ensure a remember token is created prior to saving 
  before_create :create_remember_token
  
# validate password min length -  has_secure_password validates matching, presence,
# and adds an authenticate method to put the hash in password_digest
  validates :password, length: { minimum: 6 }
  has_secure_password
  
# new token and encrypt are attached to the User class because they are used
# outside the User model and don't require a user instance to function
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end

# the SHA encryption is used because it is much faster than bcrypt and needs to
# be used on every page/often.  to_s is used because sometimes in test environments
# there will be a nil token(?)
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end

#no need to expose this to the outside as its only used in User model
  private
# extra indentation to clearly show which methods are private is good practice
      def create_remember_token
        self.remember_token = User.encrypt(User.new_remember_token)
      end
  
end
