require "test_helper"

class Users::SettingsControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get users_settings_index_url
    assert_response :success
  end
end
