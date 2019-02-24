class LikesController < ApplicationController
  before_action :logged_in_user
  def create
    @like = Like.create!(like_params)
    if @like.save
      respond_to do |format|
      format.html {redirect_to request.referrer}
      format.js
    end
    end
  end

  def destroy
    @likes = Like.find(params[:id])
    @micropost = Micropost.find(@likes.micropost_id)
    @like = @micropost.likes.build
    Like.find(params[:id]).destroy
    respond_to do |format|
      format.html {redirect_to request.referrer}
      format.js
    end
  end

  private

  def like_params
    params.require(:like).permit(:user_id, :micropost_id)
  end
end
