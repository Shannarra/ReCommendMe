# frozen_string_literal: true

class Recommendation < ApplicationRecord
  has_one_attached :cv

  scope :only_valid, ->() {
    where.not(
      user_id: nil,
      to: '',
    )
  }

  scope :cv_path, ->(id:) { ActiveStorage::Blob.service.send(:path_for, Recommendation.find(id).cv.key) }

  scope :for_user, ->(id:) { only_valid.where(user_id: id) }
end
