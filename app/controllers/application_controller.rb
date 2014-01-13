class ApplicationController < ActionController::Base
  protect_from_forgery
  respond_to :html, :js

  private

  def first_page?
    params[:page].blank? || params[:page].to_i <= 1
  end

  def tag_names_by_params(target=nil)
    tag_names = target ? params[target].delete(:tags) : params.delete(:tags)
    tag_names ||= []
    tag_names.map! {|tag_name| tag_name.strip }
    tag_names.reject!(&:blank?)
  end

  def update_tags_for(obj, tag_names)
    return if tag_names.blank?
    obj_tag_names = Tag.for(obj).pluck(:name)
    add_tag_names = tag_names - obj_tag_names
    remove_tag_names = obj_tag_names - tag_names
    Tag.where(name: remove_tag_names).for(obj).destroy_all if remove_tag_names.any?
    add_tag_names.each do |add_tag_name|
      obj.tags.create!(name: add_tag_name, user: current_user)
    end
  end
end
