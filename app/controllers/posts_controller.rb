class PostsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :ensure_owner, only: [:edit, :update, :destroy]

  def index
    @posts = Post.includes(:user).order(created_at: :desc)
  end

  def show
  end

  def new
    @post = current_user.posts.build
  end

  def create
    @post = current_user.posts.build(post_params)
    if @post.save
      redirect_to posts_path, notice: 'โพสต์ถูกสร้างเรียบร้อยแล้ว'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
  end

  def update
    if @post.update(post_params)
      redirect_to posts_path, notice: 'โพสต์ถูกอัปเดตเรียบร้อยแล้ว'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @post.destroy
    redirect_to posts_path, notice: 'โพสต์ถูกลบเรียบร้อยแล้ว'
  end

  private

  def set_post
    @post = Post.find(params[:id])
  end

  def ensure_owner
    unless @post.user == current_user
      redirect_to posts_path, alert: 'คุณไม่มีสิทธิ์ดำเนินการนี้'
    end
  end

  def post_params
    params.require(:post).permit(:content, :image)
  end
end
