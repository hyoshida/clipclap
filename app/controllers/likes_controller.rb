# -*- encoding: utf-8 -*-
class LikesController < ApplicationController
  def index
    raise unless params[:user_id]

    @user = User.includes(:clips, :likes, :tags).find(params[:user_id])
    raise unless @user

    # TODO: 削除したクリップがnilになるのでその情報をフロントに反映する
    @clips = @user.likes.order(:updated_at).map(&:clip).compact
  rescue
    flash[:alert] = 'ユーザーが見つかりません'
  end
end
