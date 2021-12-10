# frozen_string_literal: true

class Recommendation < ApplicationRecord
  has_one_attached :cv

  scope :cv_path, ->(id:) { ActiveStorage::Blob.service.send(:path_for, Recommendation.find(id).cv.key) }

  scope :for_user, ->(id:) { where(user_id: id) }
end
