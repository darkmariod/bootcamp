# Preview all emails at http://localhost:3000/rails/mailers/submission_mailer
class SubmissionMailerPreview < ActionMailer::Preview

  # Preview this email at http://localhost:3000/rails/mailers/submission_mailer/new_response
  def new_response
    submission = Submission.first
    comment = submission.comments.first

    SubmissionMailer.with(submission: submission, comment: comment).new_response
  end
end
