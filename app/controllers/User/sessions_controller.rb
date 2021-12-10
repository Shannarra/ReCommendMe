# frozen_string_literal: true

module User
  class SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]

    respond_to :json

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    # def create
    #   super
    # end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end

    private

    def respond_with(_res, *_opts)
      if current_user
        render json: {
          message: 'Logged in'
        }, status: :ok
      else
        render json: {
          message: 'Log in first'
        }, status: :ok
      end
    end

    def log_out_success
      render json: {
        message: 'Logged out'
      }, status: :ok
    end

    def log_out_fail
      render json: {
        message: 'Logging out failed'
      }, status: :unauthorized
    end

    def respond_to_on_destroy
      return log_out_success if current_user

      log_out_fail
    end
  end
end
