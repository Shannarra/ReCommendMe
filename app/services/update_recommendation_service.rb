# frozen_string_literal: true

class UpdateRecommendationService
  def initialize(rec, params)
    @rec = rec
    @params = params
  end

  def call
    if @params[:cv] && !file?(@params[:cv])
      delete_cv if @rec.cv.attached?
      @params.delete(:cv)
    end

    @rec.update(@params)
  end

  def file?(par)
    par.is_a?(ActionDispatch::Http::UploadedFile)
  end

  def delete_cv
    @rec.cv.purge
  end
end
