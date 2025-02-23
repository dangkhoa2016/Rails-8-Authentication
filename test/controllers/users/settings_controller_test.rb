require "test_helper"

class Users::SettingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get user_settings_url
    assert_response :success
  end
end
