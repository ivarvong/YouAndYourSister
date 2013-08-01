class PostsController < ApplicationController
  before_action :set_post, only: [:show, :edit, :update, :destroy]
  before_action :admin_check, only: [:edit, :update, :destroy, :not_approved, :approve]
  before_action :logged_in, only: [:create_like, :destroy_like]
  # GET /posts
  # GET /posts.json
  def index
    #@new_post = Post.new
    @posts = Post.where(approved: true).order('created_at DESC').includes(:likes)
  end

  def not_approved
    @posts = Post.where(approved: false).order('created_at ASC')
  end

  def most
    most_timing = Benchmark.ms do 
      @posts = Post.where(approved: true).includes(:likes).to_a.map{|post|
        [post, post.likes.count]
      }.sort_by{|item|
        -item[1]
      }.map{|post, like_count|        
        post
      }
    end
    logger.debug "most_timing:#{most_timing}"
  end

  def approve
    @post = Post.find(params[:id])
    @post.approved = true
    if @post.save
      redirect_to not_approved_path, notice: "Approved!"
    else
      redirect_to not_approved_path, notice: "Oops, there was an issue approving that."
    end
  end

  def create_like
    post = Post.find(params[:post_id])
    like = Like.create(user_id: current_user.id, post_id: post.id)
    if like.save and post.save
      render :json => post.likes.count
    else
      render :json => false, :status => 422
    end
  end

  def destroy_like
    post = Post.find(params[:post_id])
    like = Like.where(user_id: current_user.id, post_id: post.id)
    if like.destroy and post.save
      render :json => post.likes.count
    else
      render :json => false, :status => 422
    end
  end

  def by_nickname
    @user = User.where(nickname: params[:nickname].downcase).first
    @posts = @user.likes.map{|like|
      [like.created_at, like.post]
    }.sort_by{|created_at, post|
      -1*created_at.to_i
    }.map{|created_at, post|
      post
    } 
  end

  # GET /posts/1
  # GET /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = Post.new
  end

  # GET /posts/1/edit
  def edit
  end

  # POST /posts
  # POST /posts.json
  def create
    @post = Post.new(post_params)
    @post.approved = false # double check this

    respond_to do |format|
      if @post.save
        format.html { redirect_to root_url, notice: 'Post was successfully created.' }
        format.json { render action: 'show', status: :created, location: @post }
      else
        format.html { render action: 'new' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1
  # PATCH/PUT /posts/1.json
  def update
    respond_to do |format|
      if @post.update(post_params)
        format.html { redirect_to @post, notice: 'Post was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /posts/1
  # DELETE /posts/1.json
  def destroy
    @post.destroy
    respond_to do |format|
      format.html { redirect_to posts_url }
      format.json { head :no_content }
    end
  end

  def hello
    render :json => {
      user_count: User.count,
      post_count: Post.count,
      like_count: Like.count
    }
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def post_params
      params.require(:post).permit(:title, :user_id, :approved, :post_id)
    end

    def admin_check
      redirect_to root_url and return unless current_user.present? and current_user.admin?
    end

    def logged_in
      render :json => "not logged in", :status => 422 and return unless current_user.present?
    end
end
