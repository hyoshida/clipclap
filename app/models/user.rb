# -*- encoding: utf-8 -*-
class User < ActiveRecord::Base
  has_many :clips
  has_many :likes, :dependent => :destroy
  has_many :tags, :dependent => :destroy

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         :omniauthable, :omniauth_providers => [ :facebook ]

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me
  attr_accessible :provider, :uid, :name

  validates :email, :presence => true, :format => { :with => /^.{1,}@.{2,}\..{2,}$/ }

  def self.find_for_facebook_oauth(auth, signed_in_resource=nil)
    user = self.where(provider: auth.provider, uid: auth.uid).first
    user ||= self.create_with_auth(auth)
    user
  end

  def self.create_with_auth(auth)
    User.create(
      name: auth.extra.raw_info.name,
      provider: auth.provider,
      uid: auth.uid,
      email: auth.info.email,
      password: Devise.friendly_token[0, 20]
    )
  end

  def self.new_with_session(params, session)
    super.tap do |user|
      if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
        user.email = data["email"] if user.email.blank?
      end
    end
  end

  def nick_name
    self.name.presence || self.email
  end

  def like?(clip)
    Like.where(user_id: self.id, clip_id: clip.id).count.nonzero?
  end

  def unlike?(clip)
    not like?(clip)
  end

  def like(clip)
    Like.create(
      user_id: self.id,
      clip_id: clip.id,
      image_master_id: clip.image_master_id
    )
  end

  def unlike(clip)
    Like.where(user_id: self.id, clip_id: clip.id).first.destroy
  end
end
