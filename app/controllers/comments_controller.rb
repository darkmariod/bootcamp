class CommentsController < ApplicationController
  include ActionView::RecordIdentifier
  before_action :authenticate_user!
  before_action :set_comment, only: [:edit, :update, :destroy, :show, :upvote, :downvote]
  before_action :set_submission

  def new
  end

  def create
    @comment = @submission.comments.new(comment_params)
    @comment.user = current_user

    respond_to do |format|
      if @comment.save
        send_comment_notification
        format.turbo_stream
        format.html { redirect_to submission_path(@submission), notice: "Comment created successfully" }
      else
        format.turbo_stream
        format.html { redirect_to submission_path(@submission), alert: "Comment could not be created." }
      end
    end
  end

  def edit
  end

  def update
    respond_to do |format|
      if @comment.update(comment_params)
        format.turbo_stream
        format.html { redirect_to submission_path(@submission), notice: "Comment create successfully" }
      else
        format.turbo_stream
        format.html { redirect_to submission_path(@submission), alert: "Comment could not be created." }
      end
    end
  end

  def destroy
    @comment.destroy
    redirect_to submissions_path(@submission)
  end

  def upvote
    respond_to do |format|
      unless current_user.voted_for? @comment
        @comment.upvote_by current_user
        format.turbo_stream { render turbo_stream: turbo_stream.replace("#{dom_id(@comment)}_votes_count", @comment.total_vote_count)
      }
      else
        format.html { redirect_to submission_path(@submission), alert: "You already voted for this submission."}
      end
    end
  end

  def downvote
    respond_to do |format|
      unless current_user.voted_for? @comment
        @comment.downvote_by current_user
        format.turbo_stream { render turbo_stream: turbo_stream.replace("#{dom_id(@comment)}_votes_count", @comment.total_vote_count)
      }
      else
        format.html { redirect_to submission_path(@submission), alert: "You already voted for this submission."}
      end
    end
  end

  private

    def send_comment_notification
      unless @submission.user == @comment.user
        if @submission.user.comment_subscription?
          SubmissionMailer.with(comment: @comment, submission: @submission).new_response.deliver_later
        end
      end
    end

    def set_submission
      @submission = Submission.find(params[:submission_id])
    end

    def set_comment
      @comment = Comment.find(params[:id])
    end

    def comment_params
      params.require(:comment).permit(:reply, :submission_id)
    end
end
