class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html, :js

  private

  def first_page?
    params[:page].blank? || params[:page].to_i <= 1
  end
end
