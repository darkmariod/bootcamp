class User < ApplicationRecord
  extend FriendlyId
  before_create :add_unsubscribe_hash
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
  has_many :communities
  has_many :submissions, dependent: :destroy
  has_many :comments

  has_many :subscriptions
  has_many :communities, through: :subscriptions

  validates_uniqueness_of :username
  validates_presence_of :username

  has_many :subscribed_submissions, through: :communities, source: :submissions

  has_many :premium_subscriptions, dependent: :destroy

  acts_as_voter

  friendly_id :slug_candidates, use: [:slugged, :finders]

  def slug_candidates
    [:username, [:username, :id]]
  end

   def should_generate_new_friendly_id?
    if !slug?
      username_changed?
    else
      false
    end
  end


  def subscribed?
    premium_subscriptions.where(status: 'active').any?
  end

  private

    def add_unsubscribe_hash
      self.unsubscribe_hash = SecureRandom.hex
    end
end
