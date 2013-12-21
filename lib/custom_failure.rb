class CustomFailure < Devise::FailureApp
  def redirect_url
    if warden_options[:scope] == :user
      new_user_registration_path
    else
      super
    end
  end

  def respond
    if http_auth?
      http_auth
    else
      redirect
    end
  end

  def redirect_to(options={}, response_status={})
    # If you are using XHR requests other than GET or POST and redirecting after the request
    # then some browsers will follow the redirect using the original request method.
    # This may lead to undesirable behavior such as a double DELETE.
    # To work around this you can return a 303 See Other status code which will be followed using a GET request.
    # -- from http://api.rubyonrails.org/classes/ActionController/Redirecting.html
    default_response_status = { status: 303 }
    super options, default_response_status.merge(response_status)
  end
end
