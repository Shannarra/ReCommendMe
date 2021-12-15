# frozen_string_literal: true

class RecommendationSerializer < ActiveModel::Serializer
  include Rails.application.routes.url_helpers

  attributes :id, :by, :to, :updated_at, :send_now, :time_sent, :cv

  def updated_at
    object.updated_at.to_date
  end

  def cv
    return unless object.cv.attached?

    object.cv.blob.attributes
          .slice('filename', 'byte_size')
          .merge(url: cv_url)
          .tap do |attr|
            attr['name'] = attr.delete('filename')
            attr['size_b'] = attr.delete('byte_size')
          end
  end

  def time_sent
    object.time_sent
  end

  def cv_url
    url_for cv_path(id: object.id)
  end

  private

  def cv_path(id:)
    ActiveStorage::Blob.service.send(:path_for, Recommendation.find(id).cv.key)
  end
end
