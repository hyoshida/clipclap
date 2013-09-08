# -*- encoding: utf-8 -*-
class ImageMastersController < ApplicationController
  # GET /image_masters/1
  def show
    image_master = ImageMaster.find(params[:id])
    return if image_master.nil?
    image_master.create_thumb_cache_file unless File.exist? image_master.thumb_path
    send_data File.binread(image_master.thumb_path)
  end
end
