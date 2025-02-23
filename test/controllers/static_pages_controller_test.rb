require "test_helper"

class StaticPagesControllerTest < ActionDispatch::IntegrationTest
  test "should get about" do
    get about_static_pages_path
    assert_response :success
  end

  test "should get contact" do
    get contact_static_pages_path
    assert_response :success
  end

  test "should get faqs" do
    get faqs_static_pages_path
    assert_response :success
  end

  test "should get features" do
    get features_static_pages_path
    assert_response :success
  end
end
