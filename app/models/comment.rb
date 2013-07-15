class Comment < ActiveRecord::Base
  belongs_to :clip
  belongs_to :user

  default_scope order: 'created_at ASC'

  validates :clip_id, :presence => true
  validates :user_id, :presence => true
  validates :body, :presence => true
end
