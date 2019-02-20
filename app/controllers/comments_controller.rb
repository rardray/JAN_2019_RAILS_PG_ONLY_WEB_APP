class CommentsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy]

  def create
    @comment = Comment.create!(comment_params)
    if @comment.save
      flash[:success] = "Added Comment"
      redirect_to micropost_path(@comment.micropost_id)
    end
  end

  def destroy
    @comment = Comment.find(params[:id])
    if @comment.present?
      @comment.destroy
      flash[:success] = 'Comment Deleted'
      redirect_to request.referrer || root_url
    end
  end

  private

  def comment_params
    params.require(:comment).permit(:content, :user_id, :micropost_id)
  end

end
