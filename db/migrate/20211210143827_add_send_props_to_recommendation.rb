class AddSendPropsToRecommendation < ActiveRecord::Migration[6.1]
  def change
    add_column :recommendations, :send_now, :boolean, default: false
    add_column :recommendations, :time_sent, :date
  end
end
