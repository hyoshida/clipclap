module OpenUriSweet
  require 'open-uri'
  require 'open_uri_redirections'

  def open_uri_sweet(uri, mode=nil, options={}, &block)
    default_options = { allow_redirections: :all, ssl_verify_mode: OpenSSL::SSL::VERIFY_NONE }
    OpenURI.open_uri(uri, *[ mode, default_options.merge(options) ].compact, &block)
  end
end
