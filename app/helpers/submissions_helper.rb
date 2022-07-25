module SubmissionsHelper
  def inject_feed_ad(index)
    unless user_signed_in? && current_user.subscribed?
      if((index + 1) % 3 == 0)
        render partial: "feed_ad"
      end
    end
  end
end
