# frozen_string_literal: true

class MembersController < ApplicationController
  before_action :authenticate_user!

  def show
    render json: {
      message: 'Logged in successfully!'
    }, status: :ok
  end
end
