class BookCommentsController < ApplicationController
  before_action :ensure_correct_user, only: [:destroy]

  def create
    book = Book.find(params[:book_id])
    comment = current_user.book_comments.new(book_comment_params)
    comment.book_id = book.id
    comment.save
    redirect_back(fallback_location: root_path)
    # エラーメッセージ表示機能 render時にcommentのパスが生成されてしまう
    # if comment.save
    #   redirect_back(fallback_location: root_path)
    # else
    #   @error_comment = comment
    #   @book = Book.find(params[:book_id])
    #   @user = User.find(@book.user_id)
    #   @new_book = Book.new
    #   @book_comment = BookComment.new
    #   render "books/show"
    # end
  end

  def destroy
    BookComment.find(params[:id]).destroy
    redirect_back(fallback_location: root_path)
  end

  private

  def book_comment_params
    params.require(:book_comment).permit(:comment)
  end

  def ensure_correct_user
    @book = Book.find(params[:book_id])
    @user = User.find(@book.user_id)
    unless @user == current_user
      redirect_to user_path(current_user)
    end
  end
end
