class UsersController < ApplicationController
  before_action :set_user, only: [:show, :edit, :update, :destroy, :follow, :unfollow, :followers]

#-----------------0831
  skip_before_action :authenticate_user, except: [ :new, :create ]

  # GET /users
  # GET /users.json
  def index
    if params[:search].blank?
    @users = User.all.paginate(page: params[:page])
    else
      @users = User.search do
        fulltext params[:search]
        paginate(page: params[:page])
        order_by :created_at, :desc
      end.results
    end
  end

  # GET /users/1
  # GET /users/1.json
  def show
    @posts = @user.posts.paginate(page: params[:page])
  end

  # GET /users/new
  def new
    @user = User.new
  end

  # GET /users/1/edit
  def edit
  end

  # POST /users
  # POST /users.json
  def create
    @user = User.new(user_params)

#    respond_to do |format|
      if @user.save
        redirect_to @user, notice: 'User was successfully created.' 
#        format.json { render action: 'show', status: :created, location: @user }
      else
        render action: 'new' 
#        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
#  end

  # PATCH/PUT /users/1
  # PATCH/PUT /users/1.json
  def update
    respond_to do |format|
      if @user.update(user_params)
        format.html { redirect_to @user, notice: 'User was successfully updated.' }
        format.json { head :no_content }
      else
        format.html { render action: 'edit' }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /users/1
  # DELETE /users/1.json
  def destroy
    @user.destroy
    respond_to do |format|
      format.html { redirect_to users_url }
      format.json { head :no_content }
    end
  end

#--------------0831
  def follow
    if current_user?(@user) # 這個用戶是你自己嗎
      flash[:error] = "You cannot follow yourself"
    elsif current_user.following?(@user) # 你是不是以經在追隨這個用戶了
      flash[:error] = "You already follow #{@user.name}"
    else
      unless current_user.follow(@user).nil? # 如果追隨這個用戶沒有失敗
        flash[:success] = "You are following #{@user.name}"
      else # 任何其它的狀況
        flash[:error] = "Something went wrong.  You cannot follow #{@user.name}"
      end
      redirect_to @user
    end
  end

  def unfollow
    if current_user.unfollow(@user) # 如果取消追隨成功
      flash[:success] = "You no longer follow #{@user.name}"
    else # 如果發生任何其它的狀況
      flash[:error] = "You cannot unfollow #{@user.name}"
    end
    redirect_to @user
  end

  def followers
    @users = @user.followers.paginate(page: params[:page])
    @title = "Followers"
    render "followings" 
  end

   def followings
    @users = @user.followed_users.paginate(page: params[:page])
    @title = "Followed Users"
    render "followings"
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_user
      @user = User.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def user_params
      params.require(:user).permit(:name, :email, :phone, :password, :password_confirmation)
    end
end
