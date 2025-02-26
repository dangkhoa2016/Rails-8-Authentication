require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  def login(user)
    open_session do |sess|
      u = users(user)
      sess.post new_user_session_url, params: { user: { email: u.email, password: "password" } }
      sess.follow_redirect!
      assert_equal root_path, sess.path, "Sign in as #{user} user successful"
    end
  end

  setup do
    ENV["ADMIN_EMAIL"] = users(:super_admin).email
    @super_admin_session = login(:super_admin)
    @admin_session = login(:admin)
  end

  def new_user_params
    {
      user: {
        email: "new_user@local.test", password: "password", first_name: "New", last_name: "User"
      }
    }
  end

  def edit_user_params
    {
      user: {
        email: "modify_email@local.test",
        first_name: "Modify",
        last_name: "User", username: "modify_user",
        role: "admin",
        date_of_birth: "2000-01-01",
        password: "password123"
      }
    }
  end

  test "should get index" do
    @super_admin_session.get users_url
    assert_equal 200, @super_admin_session.response.status
    assert_equal 5, @super_admin_session. controller.instance_variable_get(:@users).count
    # assert_template 'users/index'
    # assert_not_nil assigns(:users)

    @admin_session.get users_url
    assert_equal 200, @admin_session.response.status
    assert_equal 5, @admin_session.controller.instance_variable_get(:@users).count
  end

  test "should allow super admin to create user" do
    @super_admin_session.post create_users_url, params: new_user_params
    assert_equal 302, @super_admin_session.response.status
    user = @super_admin_session.controller.instance_variable_get(:@user)
    assert_not_nil user
    assert_equal "New User", user.full_name
    assert_equal "user", user.role
    assert_equal "new_user@local.test", user.username
    assert_nil user.date_of_birth
  end

  test "should not allow admin to create user" do
    @admin_session.post create_users_url, params: new_user_params
    assert_equal 403, @admin_session.response.status
    assert_includes @admin_session.response.body, "You are not authorized to perform this action."
    assert_nil @admin_session.controller.instance_variable_get(:@user)
  end

  test "should allow super admin to get new user page" do
    @super_admin_session.get new_user_url
    assert_equal 200, @super_admin_session.response.status
  end

  test "should not allow admin to get new user page" do
    @admin_session.get new_user_url
    assert_equal 403, @admin_session.response.status
    assert_includes @admin_session.response.body, "You are not authorized to perform this action."
  end

  test "should allow super admin to get edit user page" do
    @super_admin_session.get edit_user_url(users(:one))
    assert_equal 200, @super_admin_session.response.status
  end

  test "should not allow admin to get edit user page" do
    @admin_session.get edit_user_url(users(:one))
    assert_equal 403, @admin_session.response.status
    assert_includes @admin_session.response.body, "You are not authorized to perform this action."
  end

  test "should allow super admin to update user" do
    @super_admin_session.put user_url(users(:one)), params: edit_user_params
    assert_equal 302, @super_admin_session.response.status
    user = @super_admin_session.controller.instance_variable_get(:@user)
    assert_not_nil user
    assert_equal "modify_email@local.test", user.email
    assert_equal "Modify User", user.full_name
    assert_equal "admin", user.role
    assert_equal "modify_user", user.username
    assert_nil user.unconfirmed_email
    assert_equal Date.new(2000, 1, 1), user.date_of_birth
  end

  test "should not allow admin to update user" do
    @admin_session.put user_url(users(:one)), params: edit_user_params
    assert_equal 403, @admin_session.response.status
    assert_includes @admin_session.response.body, "You are not authorized to perform this action."
  end

  test "should allow super admin to delete user" do
    @super_admin_session.delete user_url(users(:one))
    assert_equal 302, @super_admin_session.response.status
  end

  test "should not allow admin to delete user" do
    @admin_session.delete user_url(users(:one))
    assert_equal 403, @admin_session.response.status
    assert_includes @admin_session.response.body, "You are not authorized to perform this action."
  end
end
