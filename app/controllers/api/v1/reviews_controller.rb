class Api::V1::ReviewsController < ApplicationController
  before_action :set_Book, only: :index
  before_action :set_review, only: [:show, :update, :destroy]
  before_action :authenticate_with_token!, only: [:show, :update, :destroy]


  def index
    @reviews = @book.reviews
    reviews_serializer = parse_json(@reviews)
    json_response("Index reviews successfully", true, {reviews: reviews_serializer}, :ok)
  end

  def show
    reviews_serializer = parse_json(@review)
    json_response("Show Review successfully", true, {review: reviews_serializer}, :ok)

  end

  def create
    review = Review.new(review_params)
    review.user_id = current_user.id
    review.book_id = params[:book_id]
    if review.save
      reviews_serializer = parse_json(review)
      json_response("Review created successfully", true, {review: reviews_serializer}, :ok)
    else
      json_response("Review Not created", false, {}, :unprocessable_entity)
    end

  end

  def update
    if correct_user(@review.user)
      if @review.update(review_params)
        reviews_serializer = parse_json(@review)
        json_response("Update Review Succesfully", true, {review: reviews_serializer}, :ok)
      else
        json_response("Review Not Updated", false, {}, :unprocessable_entity)
      end
    else
      json_response("You don't have permission to update", false , {}, :unauthorized)
    end

  end

  def destroy
    if correct_user(@review.user)
      if @review.destroy
        json_response("Deleted Review Succesfully", true, {}, :ok)
      else
        json_response("Delete Review Fail", false, {}, :unprocessable_entity)
      end
    else
      json_response("You don't have permission to update", false , {}, :unauthorized)
    end

  end

  private

  def set_review
    @review = Review.find_by(id: params[:id])
    unless @review.present?
      json_response("No Review found", false, {}, :not_found)
    end
  end

  def set_Book
    @book = Book.find_by(id: params[:book_id])
    unless @book.present?
      json_response("No Book found", false, {}, :not_found)
    end
  end

  def review_params
    params.require(:review).permit(:title, :content_rating, :recommend_rating)
  end

end