module BreadcrumbHelper
  def devise_friendly_name
    case controller_name
    when "sessions"
      "Sign In"
    when "registrations"
      devise_registrations_action
    when "passwords"
      devise_passwords_action
    when "confirmations"
      "Confirm Email"
    when "unlocks"
      "Unlock Account"
    else
      controller_name.titleize
    end
  end

  def devise_passwords_action
    case action_name
    when "new"
      "Forgot Password"
    when "edit"
      "Change Password"
    end
  end

  def devise_registrations_action
    case action_name
    when "new"
      "Register"
    when "edit"
      "Edit Profile"
    else
      "View Profile"
    end
  end

  def breadcrumb_url
    if respond_to?("#{controller_name}_path")
      send("#{controller_name}_path")
    else
      controller_name.titleize
    end
  end

  def breadcrumb_content
    @breadcrumb_content ||= begin
      if devise_controller?
        devise_friendly_name
      elsif controller_name == "static_pages"
        controller.action_name.titleize
      elsif controller_name.in?(%w[home search])
        controller_name.titleize
      elsif response.status == 403
        response.status_message
      elsif params[:controller] == "users/settings"
        "User Settings"
      end
    end
  end
end
