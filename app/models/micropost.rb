class Micropost < ActiveRecord::Base
  belongs_to :user
  # this is a proc or lamda - DESC is SQL for descending
  # this creates reverse order of created_at time or most recent first
  default_scope -> { order('created_at DESC') }
  validates :user_id, presence: true
  validates :content, presence: true, length: {maximum: 140}
end
