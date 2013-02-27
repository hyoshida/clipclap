class Comment < ActiveRecord::Base
  belongs_to :post
  belongs_to :user

  default_scope order: 'created_at ASC'

  validates :post_id, :presence => true
  validates :user_id, :presence => true
  validates :body, :presence => true
end
