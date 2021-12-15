class AddRecommendedEmailToRecommendation < ActiveRecord::Migration[6.1]
  def change
    add_column :recommendations, :to, :string, default: "", null: false
  end
end
