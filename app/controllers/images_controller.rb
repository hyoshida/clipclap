# -*- encoding: utf-8 -*-
class ImagesController < ApplicationController
  # GET /images/1
  def show
    image = Image.find(params[:id])
    return if image.nil?

    case params[:type].try(:to_sym)
    when :thumbnail
      image.create_thumb_cache_file unless File.exist? image.thumb_path
      send_data File.binread(image.thumb_path)
    else
      send_data image.open_image.read
    end
  end
end
