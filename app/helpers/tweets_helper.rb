module TweetsHelper
  def create_render_streams(tweet)
    user_gid = current_user.to_gid_param

    private_target = "#{user_gid} tweet_#{tweet.id} private_likes"
    public_target = "tweet_#{tweet.id}_public_likes"
    if current_user
      [private_stream(tweet, user_gid, private_target),
       public_stream(tweet, public_target)]
    else
      public_stream(tweet, public_target)
    end
  end

  private

  def private_stream(tweet, user_gid, private_target)
    turbo_stream.replace(private_target,
                         partial: 'likes/private_button',
                         locals: { tweet: tweet,
                                   like_status: current_user.liked?(tweet),
                                   user_gid: user_gid })
  end

  def public_stream(tweet, public_target)
    tweet.replace(public_target,
                  partial: 'likes/like_count',
                  locals: { tweet: tweet })
  end
  #   def broadcast_update(tweet)
  #     respond_to do |format|
  #       format.turbo_stream do
  #         broadcast_to_authorized_streams(tweet)
  #       end
  #     end
  #   end

  #   private

  #   def broadcast_to_authorized_streams(tweet)
  #     if current_user
  #       render turbo_stream: [
  #         private_stream(tweet),
  #         public_stream(tweet)
  #       ]
  #     else
  #       render turbo_stream: public_stream(tweet)
  #     end
  #   end

  #   def private_stream(tweet)
  #     turbo_stream.update("tweet_#{tweet.id}",
  #                         partial: 'tweets/private_tweet',
  #                         locals: { tweet: tweet,
  #                                   like_status: current_user.liked?(@tweet),
  #                                   user_id: current_user.id })
  #   end

  #   def public_stream(tweet)
  #     turbo_stream.update("tweet_#{tweet.id}_like_count",
  #                         partial: 'likes/like_count',
  #                         locals: { tweet: tweet })
  #   end
end
