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
      # エラーメールが大量に飛ぶのを避ける為に、
      # 拡大画像が取得できない場合は空レスポンスを返す
      send_data image.open_image.read rescue render nothing: true
    end
  end
end
