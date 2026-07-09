class CaseNote < ApplicationRecord
  belongs_to :legal_case
  belongs_to :user

  validates :body, presence: true
end
