class UsersController < ApplicationController
  before_action :set_user, except: [:index, :timeline]
  before_action :blocking_test_user, only: [:edit, :update, :destroy]

  def index
    @users = User.all
  end

  def show
    @tweets = @user.tweets.order('updated_at desc').page(params[:page]).per(5)
    
    if user_signed_in?
      @currentUserEntry = Entry.where(user_id: current_user.id)
      @userEntry = Entry.where(user_id: @user.id)
      unless @user.id == current_user.id
        @currentUserEntry.each do |cu|
          @userEntry.each do |u|
            if cu.room_id == u.room_id
              @haveRoom = true
              @roomId = cu.room_id
            end
          end
        end
        unless @haveRoom
          @room = Room.new
          @entry = Entry.new
        end
      end
    end
  end

  def edit
    if @user.id != current_user.id
      redirect_to root_path, notice: "不正な操作です"
    end
  end

  def update
    if current_user.update(user_params)
      # redirect_to root_path
      # redirect_back(fallback_location: root_path)
      redirect_to root_path, notice: 'ユーザー情報をしました'
    else 
      render :edit
    end
  end

  def likes
  end

  def following
      @users = @user.following
  end

  def followers
      @users = @user.followers
  end

  def timeline
    @tweets_all = Tweet.includes(:user)
    @user = User.find(current_user.id)
    @following_users = @user.following
    @tweets = @tweets_all.where(user_id: @following_users).order('updated_at desc').page(params[:page]).per(5)
    
  end

  private

  def test_user

  end

  def set_user
    @user = User.find(params[:id])
  end

    def user_params
      params.require(:user).permit(:nickname, :email, :avatar)
    end

  def blocking_test_user
    if @user.email == "guest@user"
      flash[:notice] = "ゲストユーザーのため編集できません"
      redirect_back(fallback_location: root_path)
    end
  end

end