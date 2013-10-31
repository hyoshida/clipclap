# -*- encoding: utf-8 -*-
class User < ActiveRecord::Base
  has_many :clips
  has_many :likes, :dependent => :destroy
  has_many :tags, :dependent => :destroy

  acts_as_followable
  acts_as_follower

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
    user ||= self.create_or_update_with_auth(auth)
    user
  end

  def self.create_or_update_with_auth(auth)
    user = self.where(email: auth.info.email).first
    return self.create_with_auth(auth) if user.nil?
    user.update_with_auth(auth)
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

  def update_with_auth(auth)
    self.update_attributes(
      provider: auth.provider,
      uid: auth.uid
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
    self.likes.exists?(clip_id: clip.id)
  end

  def unlike?(clip)
    not like?(clip)
  end

  def like(clip)
    self.likes.create(
      clip_id: clip.id,
      image_master_id: clip.image_master_id
    )
  end

  def unlike(clip)
    self.likes.where(clip_id: clip.id).first.destroy
  end

  def reclip?(clip)
    self.clips.exists?(parent_id: clip.id)
  end

  def reclip(parent_clip)
    self.clips.create(
      parent_id: parent_clip.id,
      image_master_id: parent_clip.image_master_id,
      title: parent_clip.title,
      origin_url: parent_clip.origin_url,
      origin_html: parent_clip.origin_html
    )
  end
end
