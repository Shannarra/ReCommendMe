# frozen_string_literal: true

class RecommendationsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_recommendation, only: %i[update show]

  after_action :recommend_now_if_set, only: %i[create]

  FIND_EMAIL_REGEX = /([a-zA-Z0-9._-]+@[a-zA-Z0-9._-]+\.[a-zA-Z0-9_-]+)/.freeze

  def index
    render json: Recommendation.for_user(id: current_user&.id).with_attached_cv.order(:id)
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
    recommendation = Recommendation.new(recommendation_params)
    recommendation.user_id = current_user.id if recommendation.user_id.nil?

    # TODO: Add a "comment" to the recommendation!
    if recommendation.save!
      @recommendation = recommendation

      # TODO: Maybe add a worker that updates ALL that have an empty 'to'? 🤔🤔🤔
      read_and_update!
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

  private

  # rubocop:disable Metrics/MethodLength
  def read_and_update!
    if @recommendation&.to == ''
      begin
        reader = PDF::Reader.new(open_cv_file!)

        reader.pages.each do |page|
          match = page.text.match(FIND_EMAIL_REGEX)
          next unless match

          @recommendation&.update!(to: match)
          render json: @recommendation
          break
        end
      rescue ArgumentError => e
        render json: {
          message: e.message,
          error: e
        }
      end
    else
      render json: @recommendation
    end
  end
  # rubocop:enable Metrics/MethodLength

  def open_cv_file!
    File.open(Recommendation.cv_path(id: @recommendation.id))
  end

  def read_file_content!
    open_cv_file!.readlines
  end

  def recommend_now_if_set
    return if @recommendation.send_now.nil? || @recommendation.send_now == false

    # TODO: Fake run the mailer task
    @recommendation.time_sent = Time.now if !@recommendation.send_now.nil? && @recommendation.send_now == true
    @recommendation.save!
  end

  def recommendation_params
    params.permit(:by, :to, :cv, :user_id, :send_now)
  end

  def set_recommendation
    @recommendation = Recommendation.find(params[:id])
  rescue StandardError
    @recommendation = nil
  end
end
