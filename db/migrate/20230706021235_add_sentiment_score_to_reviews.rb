class AddSentimentScoreToReviews < ActiveRecord::Migration[6.1]
  def change
    add_column :reviews, :sentiment_score, :float
  end
end
