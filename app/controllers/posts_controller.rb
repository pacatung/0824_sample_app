class PostsController < ApplicationController

#----------0831
 before_action :authenticate_user, only: [ :new, :create, :index ]
 
  def index
#    @posts = Post.all.paginate(page: params[:page], :per_page=>15)
#   	@posts = Post.from_followed_users(current_user).order("created_at DESC").paginate(page: params[:page])
if params[:search].blank?
        @posts = Post.from_followed_users(current_user).order("created_at DESC").paginate(page: params[:page])
    else
      @posts = Post.search do
        fulltext params[:search]
        paginate(page: params[:page])
        order_by :created_at, :desc
      end.results
    end
    @post=current_user.posts.build
  end
  
#  def new
#   change to def index
#  end

  def create
  	@post = current_user.posts.build(create_params)
    if @post.save
        flash[:success] = "Posted successfully"
        redirect_to posts_path
    else
      render "new"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    if current_user?(@post.user)
        @post.destroy
        flash[:success] = "Post deleted"
        redirect_to posts_path
    else
        flash[:error] = "You cannot delete that post"
        redirect_to posts_path
    end
  end

  private#

  def create_params
  	params.require(:post).permit(:content)
  end

end