# -*- encoding: utf-8 -*-
class RankingController < ApplicationController
  def views
    @clips = target_clips_to_ranking_views
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clips }
    end
  end

  def likes
    @clips = target_clips_to_ranking_likes
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @clips }
    end
  end

  private

  def target_clips_to_ranking_views
    Clip
      .where.not(view_count: 0)
      .includes(:user, :image_master, :likes, :tags)
      .reorder('view_count DESC, created_at DESC')
      .limit(Settings.ranking_limit)
      .all
  end

  def target_clips_to_ranking_likes
    # TODO: 速度改善
    ImageMaster
      .includes(:clips)
      .joins(:likes)
      .sort_by {|image_master| [ -image_master.likes.count, -image_master.created_at.to_i ] }
      .map {|image_master| image_master.clips.sort_by {|clip| [ -clip.likes.count, -clip.created_at.to_i ] }.first }
      .uniq
      .slice(0..Settings.ranking_limit)
      .compact
  end
end
