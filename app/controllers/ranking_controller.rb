# -*- encoding: utf-8 -*-
class RankingController < ApplicationController
  def views
    @posts = target_posts_to_ranking_views
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  def likes
    @posts = target_posts_to_ranking_likes
    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @posts }
    end
  end

  private

  def target_posts_to_ranking_views
    Post
      .where.not(view_count: 0)
      .includes(:user, :image_master, :likes, :tags)
      .reorder('view_count DESC, created_at DESC')
      .limit(Settings.ranking_limit)
      .all
  end

  def target_posts_to_ranking_likes
    # TODO: 速度改善
    ImageMaster
      .includes(:posts)
      .joins(:likes)
      .sort_by {|image_master| [ -image_master.likes.count, -image_master.created_at.to_i ] }
      .map {|image_master| image_master.posts.sort_by {|post| [ -post.likes.count, -post.created_at.to_i ] }.first }
      .uniq
      .slice(0..Settings.ranking_limit)
      .compact
  end
end
