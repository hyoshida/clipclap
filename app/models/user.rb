# -*- encoding: utf-8 -*-
class User < ActiveRecord::Base
  has_many :clips
  has_many :likes, :dependent => :destroy
  has_many :tags, :dependent => :destroy
  has_many :matomes, :dependent => :destroy

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
  attr_accessible :description

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

  def like?(object)
    case object
    when Clip
      self.likes.exists?(clip_id: object.id)
    when Matome
      self.likes.exists?(matome_id: object.id)
    else
      raise
    end
  end

  def unlike?(object)
    not like?(object)
  end

  def like(object)
    case object
    when Clip
      like_clip(object)
    when Matome
      like_matome(object)
    else
      raise
    end
  end

  def like_clip(clip)
    self.likes.create(
      clip_id: clip.id,
      image_id: clip.image_id
    )
  end

  def like_matome(matome)
    self.likes.create(matome_id: matome.id)
  end

  def unlike(object)
    case object
    when Clip
      unlike_clip(object)
    when Matome
      unlike_matome(object)
    else
      raise
    end
  end

  def unlike_clip(clip)
    self.likes.where(clip_id: clip.id).first.destroy
  end

  def unlike_matome(matome)
    self.likes.where(matome_id: matome.id).first.destroy
  end

  def reclip?(clip)
    self.clips.exists?(parent_id: clip.id)
  end

  def reclip(parent_clip)
    self.clips.create(
      parent_id: parent_clip.id,
      image_id: parent_clip.image_id,
      title: parent_clip.title,
      origin_url: parent_clip.origin_url,
      origin_html: parent_clip.origin_html
    )
  end
end
