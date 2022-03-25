class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]

  def index
    # @books = Book.all
    @books = Book.includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}
    @book = Book.new
    @user = User.find(current_user.id)
  end

  def create
    @user = User.find(current_user.id)
    @book = Book.new(book_params)
    @book.user_id = @user.id
    if @book.save
      redirect_to book_path(@book.id), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def show
    @book = Book.find(params[:id])
    @user = User.find(@book.user_id)
    @new_book = Book.new
    @book_comment = BookComment.new
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  private

  def book_params
    params.require(:book).permit(:title, :body)
  end

  def ensure_correct_user
    @book = Book.find(params[:id])
    @user = @book.user
    redirect_to(books_path) unless @user == current_user
  end
end
