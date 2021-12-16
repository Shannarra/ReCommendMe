# frozen_string_literal: true

class UsersController < ApplicationController
  before_action :authenticate_user!, only: %i[update]

  def show
    render json: current_user
  end

  def update
    current_user.update(user_params)
  end

  private

  def user_params
    params.permit(:fname, :lname, :email, :password)
  end
end
