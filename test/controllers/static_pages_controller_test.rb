require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    get about_path
    assert_response :success
  end

  test "should get contact" do
    get contact_path
    assert_response :success
  end

  test "should get faqs" do
    get faqs_path
    assert_response :success
  end

  test "should get features" do
    get features_path
    assert_response :success
  end
end
