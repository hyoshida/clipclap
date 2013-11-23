class Matome < ActiveRecord::Base
  belongs_to :user
  has_many :clips
  has_many :likes, dependent: :destroy
  has_and_belongs_to_many :clips

  default_scope order: 'created_at DESC'

  validates :user_id, presence: true
  validates :title, presence: true
  validates :description, allow_blank: true, length: { maximum: 150 }

  attr_accessible :title
  attr_accessible :description
end
