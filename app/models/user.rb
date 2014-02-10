class User < ActiveRecord::Base
# validate presence of name - note the code below is the same as
# validates(:name, {presence: true})  - parens optional and {} opt on hash last arg
  validates :name, presence: true, length: {maximum: 50}
# checking for valid email uses a regular expression (regex) to define format
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, format: { with: VALID_EMAIL_REGEX },
            # rails infers true for uniqueness since the case_sensitive flag is set
                uniqueness: { case_sensitive: false }
  # ensure email is lowercase before saving to database to ensure dbase uniqueness
  before_save { self.email = email.downcase }
end
