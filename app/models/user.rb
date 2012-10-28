# -*- encoding: utf-8 -*-
class User < ActiveRecord::Base
  has_many :posts
  has_many :likes

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me

  validates :email, :presence => true, :format => { :with => /^.{1,}@.{2,}\..{2,}$/ }

  def nick_name
    self.name.presence || self.email
  end

  def like?(post)
    Like.where(user_id: self.id, post_id: post.id).count.nonzero?
  end

  def unlike?(post)
    not like?(post)
  end

  def like(post)
    Like.create(
      user_id: self.id,
      post_id: post.id,
      image_master_id: post.image_master_id
    )
  end

  def unlike(post)
    Like.where(user_id: self.id, post_id: post.id).first.destroy
  end
end
