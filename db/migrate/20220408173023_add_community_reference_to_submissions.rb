class AddCommunityReferenceToSubmissions < ActiveRecord::Migration[7.0]
  def change
    add_reference :submissions, :community, null: false, foreign_key: true
  end
end
