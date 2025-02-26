class UsersController < ApplicationController
  before_action :authenticate_user!
  before_action :check_if_admin
  before_action :check_if_super_admin, only: [ :edit, :update, :new, :create, :destroy ]
  before_action :set_user, only: [ :show, :edit, :update, :destroy ]

  def index
    @users = User.all
  end

  def create
    create_params = user_params.dup
    create_params[:username] = create_params[:email] if create_params[:username].blank?
    @user = User.new(create_params)
    if @user.save
      redirect_to users_path, notice: "User [#{@user.full_name}] with Id: #{@user.id} has been created successfully"
    else
      respond_to do |format|
        format.html { render :new }
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "users/form", locals: { user: @user }) }
      end
    end
  end

  def show
  end

  def new
    @user = User.new
  end

  def edit
  end

  def update
    update_params = user_params.dup
    if update_params[:email].present? && update_params[:email] != @user.email
      # @user.skip_confirmation!
      @user.skip_email_changed_notification!
      @user.skip_reconfirmation!
    end

    if @user.update(update_params)
      redirect_to users_path, notice: "User [#{@user.full_name}] with Id: #{@user.id} has been updated successfully"
    else
      respond_to do |format|
        format.html { render :edit }
        format.turbo_stream { render turbo_stream: turbo_stream.replace(@user, partial: "users/form", locals: { user: @user }) }
      end
    end
  end

  def destroy
    if @user.destroy
      redirect_to users_path, notice: "User [#{@user.full_name}] with Id: #{@user.id} has been deleted successfully"
    else
      redirect_to users_path, alert: "Failed to delete user [#{@user.full_name}] with Id: #{@user.id}"
    end
  end

  private

  def set_user
    @user = User.find(params[:id])
  end

  def user_params
    params.require(:user).permit(:first_name, :last_name, :email, :username, :password, :date_of_birth, :role)
  end

  def check_if_admin
    unless current_user.admin?
      render("errors/permission_denied", status: :forbidden) and return
    end
  end

  def check_if_super_admin
    unless current_user.super_admin?
      render("errors/actions_on_user_denied", status: :forbidden) and return
    end
  end
end
