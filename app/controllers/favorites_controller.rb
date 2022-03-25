class FavoritesController < ApplicationController
  def create
    @book = Book.find(params[:book_id])
    @user = User.find(@book.user_id)
    favorite = current_user.favorites.new(book_id: @book.id)
    favorite.save
    @books = Book.includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}

    # if params[:format] == "/books"
    #   @books = Book.includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}
    # elsif params[:format] == "/users"
    #   @books = @user.books.includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}
    # end
    # binding.pry
  end

  def destroy
    @book = Book.find(params[:book_id])
    @user = User.find(@book.user_id)
    favorite = current_user.favorites.find_by(book_id: @book.id)
    favorite.destroy
    @books = Book.includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}

    # if params[:format] == "/books"
    #   @books = Book.includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}
    # elsif params[:format] == "/users"
    #   @books = @user.books.includes(:liked_users).sort {|a,b| b.liked_users.size <=> a.liked_users.size}
    # end
    # binding.pry
  end
end
