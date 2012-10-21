# -*- encoding: utf-8 -*-
class User < ActiveRecord::Base
  has_many :posts

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
    return false if self.likes.nil?
    self.likes.split(',').include?(post.image_master_id.to_s)
  end

  def unlike?(post)
    not like?(post)
  end

  def like(post)
    if self.likes.nil?
      self.likes = post.image_master_id.to_s
    else
      self.likes += ",#{post.image_master_id.to_s}"
    end
  end

  def unlike(post)
    return if self.likes.nil?
    self.likes = (self.likes.split(',') - [ post.image_master_id.to_s ]).join(',')
  end
end
