class RecommendationsController < ApplicationController
  before_action :set_recommendation, only: [:update, :show]

  def index
    render json: Recommendation.all.with_attached_cv.order(:id)
  end

  def show
    if @recommendation.nil?
      render json: {
        message: "Recommendation with id #{params[:id]} not found.",
        error: true
      }, status: :not_found
    else
      render json: @recommendation
    end
  end

  def create
    recommendation = Recommendation.create(recommendation_params)

    if recommendation
      render json: recommendation
    else
      render json: recommendation.errors, status: :unprocessable_entity
    end
  end

  def update
    if UpdateRecommendationService.new(@recommendation, recommendation_params).call
      render json: @recommendation
    else
      render json: @recommendation.errors, status: :unprocessable_entity
    end
  end

  def open_cv_file!
    File.open(Recommendation.cv_path(id: @recommendation.id))
  end

  def read_file_content!
    open_cv_file!.readlines
  end

  private
  def recommendation_params
    params.permit(:by, :cv)
  end

  def set_recommendation
    @recommendation = Recommendation.find(params[:id])
    rescue
      @recommendation = nil
  end
end
