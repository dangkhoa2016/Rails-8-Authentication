class Users::SettingsController < ApplicationController
  def index
    render "devise/settings/index"
  end
end
