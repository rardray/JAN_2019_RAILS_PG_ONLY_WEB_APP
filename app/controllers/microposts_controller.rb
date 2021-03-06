class MicropostsController < ApplicationController
  before_action :logged_in_user, only: [:create, :destroy, :show]
  before_action :correct_user, only: :destroy

  def show 
    @micropost = Micropost.find(params[:id])
    @comments = @micropost.comments.paginate(page: params[:page])
    @comment = @micropost.comments.build
    @like = @micropost.likes.build
  end
  def create
    @micropost = current_user.microposts.build(micropost_params)
    if @micropost.save
      flash[:success] = "Successfully Posted"
      redirect_to root_url
    else
      @feed_items = []
      render 'static_pages/home'
    end
  end

  def destroy
    @micropost.destroy
    flash[:success] = "Post Successfully Deleted"
    redirect_to root_url
  end
  def likes
    @micropost = Micropost.find(params[:id])
    @likes = @micropost.likes.all
    @users = @likes.select{ |u| u.user_id}.map{|u| User.find(u.user_id)}.take(50)
    @title = 'Like'
    render 'show_likes'
  end
  private

  def micropost_params
    params.require(:micropost).permit(:content, :picture)
  end

  def correct_user
    @micropost = current_user.microposts.find_by(id: params[:id])
    redirect_to root_url if @micropost.nil?
  end
end
