module Reviews
  class LikesController < ApplicationController
    def create
      @review = Review.find(params[:review_id])
      @like = current_user.like(@review)
      respond_to do |format|
        format.js
      end
    end

    def destroy
      @review = Review.find(params[:review_id])
      @like = current_user.unlike(@review)
      respond_to do |format|
        format.js
      end
    end
  end
end