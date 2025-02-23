# frozen_string_literal: true

class Users::RegistrationsController < Devise::RegistrationsController
  before_action :must_sign_in, only: %i[show]
  before_action :configure_sign_up_params, only: [ :create ]
  before_action :configure_account_update_params, only: [ :update ]
  before_action :set_username, only: [ :create ]

  # GET /resource/sign_up
  # def new
  #   super
  # end

  # POST /resource
  # def create
  #   super
  # end

  # GET /resource/edit
  # def edit
  #   super
  # end

  # PUT /resource
  # def update
  #   super
  # end

  # DELETE /resource
  # def destroy
  #   super
  # end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  protected

  def allow_fields
    [ :first_name, :last_name, :username, :email, :password, :date_of_birth ]
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_sign_up_params
    devise_parameter_sanitizer.permit(:sign_up, keys: allow_fields)
  end

  # If you have extra params to permit, append them to the sanitizer.
  def configure_account_update_params
    devise_parameter_sanitizer.permit(:account_update, keys: allow_fields)
  end

  # The path used after sign up.
  # def after_sign_up_path_for(resource)
  #   super(resource)
  # end

  # The path used after sign up for inactive accounts.
  # def after_inactive_sign_up_path_for(resource)
  #   super(resource)
  # end

  def set_username
    return if params[:user].blank?
    params[:user][:username] = params[:user][:email]
  end

  def after_update_path_for(resource)
    sign_in_after_change_password? ? user_profile_path : new_session_path(resource_name)
  end

  private

  def must_sign_in
    authenticate_user!(force: true)
  end
end
