class BookCommentsController < ApplicationController
  before_action :ensure_correct_user, only: [:destroy]

  def create
    @book = Book.find(params[:book_id])
    @comment = current_user.book_comments.new(book_comment_params)
    @comment.book_id = @book.id
    @comment.save
  end

  def destroy
    @book = Book.find(params[:book_id])
    @comment = BookComment.find(params[:id]).destroy
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

  def ensure_correct_user
    @comment = BookComment.find(params[:id])
    @user = User.find(@comment.user_id)
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
