class Tweet < ApplicationRecord
  # has many likeables as likes
  has_many :likeables, dependent: :destroy
  has_many :likes, through: :likeables, source: :user
  belongs_to :user
  after_create_commit do
    broadcast_new_tweet
  end

  def broadcast_new_tweet
    broadcast_prepend_later_to 'public_tweets',
                               target: 'public_tweets',
                               partial: 'tweets/public_tweet',
                               locals: { tweet: self }
    broadcast_prepend_later_to 'private_tweets',
                               target: 'private_tweets',
                               partial: 'tweets/private_tweet',
                               locals: { tweet: self, like_status: false }
  end
end
