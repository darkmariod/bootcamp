class SubmissionsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :set_submission, only: %i[ show edit update destroy upvote downvote ]
  before_action :authenticate_user!, except: %i[ index show unsubscribe ]

  # GET /submissions or /submissions.json
  def index
    if user_signed_in?
      @feed_title = "My feed"
      @submissions = current_user.subscribed_submissions
    else
      @feed_title = "Select a community"
      @submissions = Submission.all
    end
  end

  # GET /submissions/1 or /submissions/1.json
  def show
    @community = @submission.community
    @subscription = @community.subscriptions.where(user: current_user).first
  end

  # GET /submissions/new
  def new
    @submission = Submission.new
  end

  # GET /submissions/1/edit
  def edit
  end

  # POST /submissions or /submissions.json
  def create
    @submission = Submission.new(submission_params)
    @submission.user_id = current_user.id

    respond_to do |format|
      if @submission.save
        format.html { redirect_to submission_url(@submission), notice: "Submission was successfully created." }
        format.json { render :show, status: :created, location: @submission }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /submissions/1 or /submissions/1.json
  def update
    respond_to do |format|
      if @submission.update(submission_params)
        format.html { redirect_to submission_url(@submission), notice: "Submission was successfully updated." }
        format.json { render :show, status: :ok, location: @submission }
      else
        format.html { render :edit, status: :unprocessable_entity }
        format.json { render json: @submission.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /submissions/1 or /submissions/1.json
  def destroy
    @submission.destroy

    respond_to do |format|
      format.html { redirect_to submissions_url, notice: "Submission was successfully destroyed." }
      format.json { head :no_content }
    end
  end

  def upvote
    respond_to do |format|
      unless current_user.voted_for? @submission
        @submission.upvote_by current_user
        format.turbo_stream { render turbo_stream: turbo_stream.replace("#{dom_id(@submission)}_votes_count", @submission.total_vote_count)
      }
      else
         format.html { redirect_back fallback_location: root_path, alert: "You already voted for this submission."}
      end
    end
  end

  def downvote
    respond_to do |format|
      unless current_user.voted_for? @submission
        @submission.downvote_by current_user
        format.turbo_stream { render turbo_stream: turbo_stream.replace("#{dom_id(@submission)}_votes_count", @submission.total_vote_count)
      }
      else
        format.html { redirect_back fallback_location: root_path, alert: "You already voted for this submission."}
      end
    end
  end

  def unsubscribe
    user = User.find_by_unsubscribe_hash(params[:unsubscribe_hash])
    user.update(comment_subscription: false)
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_submission
      @submission = Submission.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def submission_params
      params.require(:submission).permit(:title, :body, :url, :media, :community_id)
    end
end
