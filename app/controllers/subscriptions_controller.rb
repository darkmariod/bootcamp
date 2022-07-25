class SubscriptionsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_community, only: [:create, :destroy]

  def create
    @subscription = @community.subscriptions.new
    @subscription.community = @community
    @subscription.user = current_user

    respond_to do |format|
      if @subscription.save
        format.turbo_stream
        format.html { redirect_to community_path(@community), notice: "You successfully subscribed." }
      else
        format.html { redirect_to community_path(@community), alert: "Your subscription could not be saved." }
      end
    end
  end

  def destroy
    @subscription = @community.subscriptions.where(user: current_user).first
    @subscription.destroy

    respond_to do |format|
      format.html { redirect_back fallback_location: community_path(@community), notice: "You successfully unsubscribed"}
    end
  end

  private

  def set_community
    @community = Community.find(params[:community_id])
  end
end
