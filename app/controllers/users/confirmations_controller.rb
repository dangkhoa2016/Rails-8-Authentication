# frozen_string_literal: true

class Users::ConfirmationsController < Devise::ConfirmationsController
  before_action :set_user_email, only: [ :new, :show ]
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  # def create
  #   super
  # end

  # GET /resource/confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

  # protected

  # The path used after resending confirmation instructions.
  def after_resending_confirmation_instructions_path_for(resource_name)
    if signed_in? && current_user.super_admin?
      user_path(resource)
    else
      super(resource_name)
    end
  end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end

  private

  def set_user_email
    if request.query_parameters["id"].present?
      @decrypted_user_id = SimpleEncryptor.decrypt(request.query_parameters["id"])
      @user_email = User.find_by(id: @decrypted_user_id)&.email if @decrypted_user_id.present?
    end
  end
end
