class Api::V1::BooksController < ApplicationController
  before_action :set_book, only: :show

  def index
    @books = Book.all
    reviews_serializer = parse_json(@books)
    json_response("Index Books Successfully Rendered", true, {books: reviews_serializer}, :ok)
  end

  def show
    reviews_serializer = parse_json(@book)
    json_response("Show book successfully", true, {book: reviews_serializer}, :ok)
  end

  private

  def set_book
    @book = Book.find_by(id: params[:id])
    unless @book.present?
      json_response("Book not found", false, {}, :not_found)
    end
  end

end