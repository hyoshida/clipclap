module UserOmniauth
  extend ActiveSupport::Concern

  module ClassMethods
    def find_or_create_for_oauth(auth, signed_in_resource=nil)
      user = self.where(provider: auth.provider, uid: auth.uid).first
      user ||= self.create_or_update_for_oauth(auth)
      user
    end

    def new_with_session(params, session)
      super.tap do |user|
        if data = session["devise.facebook_data"] && session["devise.facebook_data"]["extra"]["raw_info"]
          user.email = data["email"] if user.email.blank?
        end
      end
    end

    def create_or_update_for_oauth(auth)
      user = self.where(email: email_for_oauth(auth)).first
      return self.create_for_oauth(auth) if user.nil?
      user.update_for_oauth(auth)
      user
    end

    def create_for_oauth(auth)
      self.create(
        name: auth.extra.raw_info.name,
        provider: auth.provider,
        uid: auth.uid,
        email: email_for_oauth(auth),
        password: Devise.friendly_token[0, 20]
      )
    end

    def email_for_oauth(auth)
      auth.info.email || "#{auth.uid}@#{auth.provider}.com"
    end
  end

  def update_for_oauth(auth)
    self.update_attributes(
      provider: auth.provider,
      uid: auth.uid
    )
  end
end
