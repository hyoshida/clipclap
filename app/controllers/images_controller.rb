# -*- encoding: utf-8 -*-
class ImagesController < ApplicationController
  # GET /images/1
  def show
    image = Image.find(params[:id])
    return if image.nil?
    image.create_thumb_cache_file unless File.exist? image.thumb_path
    send_data File.binread(image.thumb_path)
  end
end
