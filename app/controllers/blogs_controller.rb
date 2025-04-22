# frozen_string_literal: true

class BlogsController < ApplicationController
  skip_before_action :authenticate_user!, only: %i[index show]

  before_action :set_current_user_blog, only: %i[edit update destroy]

  def index
    @blogs = Blog.search(params[:term]).published.default_order
  end

  def show
    @blog = Blog.readable(current_user).find(params[:id])
  end

  def new
    @blog = Blog.new
  end

  def edit; end

  def create
    checked_params = check_params
    @blog = current_user.blogs.new(checked_params)

    if @blog.save
      redirect_to blog_url(@blog), notice: 'Blog was successfully created.'
    else
      render :new, status: :unprocessable_entity
    end
  end

  def update
    checked_params = check_params
    if @blog.update(checked_params)
      redirect_to blog_url(@blog), notice: 'Blog was successfully updated.'
    else
      render :edit, status: :unprocessable_entity
    end
  end

  def destroy
    @blog.destroy!

    redirect_to blogs_url, notice: 'Blog was successfully destroyed.', status: :see_other
  end

  private

  def set_current_user_blog
    @blog = current_user.blogs.find(params[:id])
  end

  def check_params
    if blog_params[:random_eyecatch] && !current_user.premium
      if params[:id]
        build_safe_update_params
      else
        build_safe_create_params
      end
    else
      blog_params
    end
  end

  def build_safe_update_params
    ActionController::Parameters.new({
                                       blog: {
                                         title: blog_params[:title],
                                         content: blog_params[:content],
                                         secret: blog_params[:secret],
                                         random_eyecatch: false
                                       },
                                       id: params[:id]
                                     }).permit(:id, :title, :content, :secret, :random_eyecatch)
  end

  def build_safe_create_params
    ActionController::Parameters.new({
                                       blog: {
                                         title: blog_params[:title],
                                         content: blog_params[:content],
                                         secret: blog_params[:secret],
                                         random_eyecatch: false
                                       }
                                     }).permit(:title, :content, :secret, :random_eyecatch)
  end

  def blog_params
    params.require(:blog).permit(:title, :content, :secret, :random_eyecatch)
  end
end
