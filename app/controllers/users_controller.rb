class UsersController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def show
    @user = User.find(params[:id])
    # @books = @user.books
    @books = @user.books.includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}
    @book = Book.new

    @today_books = @user.books.created_today
    @yesterday_books = @user.books.created_days_ago(1)
    @this_week_books = @user.books.created_this_week
    @last_week_books = @user.books.created_last_week
    # 前日比・前週比
    @the_day_before = ratio_post(@today_books, @yesterday_books)
    @compared_to_last_week = ratio_post(@this_week_books, @last_week_books)
  end

  def index
    @users = User.all
    @book = Book.new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    if @user.update(user_params)
      redirect_to user_path(@user.id), notice: "You have updated user successfully."
    else
      @books = @user.books
      render "edit"
    end
  end

  def search
    @user = User.find(params[:user_id])
    # @books = @user.books.includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}
    @books = @user.books
    @book = Book.new
    if params[:created_at] == ""
      @search_book = "日付を選択してください"
    else
      created_at = params[:created_at]
      @search_book = @books.where(['created_at LIKE ? ', "#{created_at}%"]).count
    end
  end

  private

  def user_params
    params.require(:user).permit(:name, :introduction, :profile_image)
  end

  def ensure_correct_user
    @user = User.find(params[:id])
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end

  def ratio_post(books, prev_books)
    prev_books.count > 0 ? (books.count.to_f / prev_books.count.to_f) * 100 : " - "
  end
end