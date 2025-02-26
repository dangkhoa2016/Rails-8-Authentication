require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "user attributes must not be empty" do
    new_user = User.new
    assert new_user.invalid?
    assert new_user.errors[:first_name].any?
    assert new_user.errors[:email].any?
    assert new_user.errors[:password].any?
    assert new_user.errors[:username].any?
  end

  test "user email must be saved as lower case" do
    new_user = User.new(users(:one).attributes.except("id"))
    new_user.email = "TEST@UPCASE.local"
    new_user.save
    assert_equal "test@upcase.local", new_user.email
  end

  test "should not save user without password" do
    new_user = User.new(users(:one).attributes.except("id"))
    new_user.save
    assert new_user.invalid?
    assert_equal [ "can't be blank" ], new_user.errors[:password]
  end

  test "should not save user without email" do
    new_user = User.new(users(:one).attributes.except("id"))
    new_user.email = nil
    new_user.save
    assert new_user.invalid?
    assert_equal [ "can't be blank" ], new_user.errors[:email]
  end

  test "should not save user without first name" do
    new_user = User.new(users(:one).attributes.except("id"))
    new_user.first_name = nil
    new_user.save
    assert new_user.invalid?
    assert_equal [ "can't be blank" ], new_user.errors[:first_name]
  end

  test "should not save user without username" do
    new_user = User.new(users(:one).attributes.except("id"))
    new_user.username = nil
    new_user.save
    assert new_user.invalid?
    assert_equal [ "can't be blank" ], new_user.errors[:username]
  end

  test "should not save user with invalid email" do
    new_user = User.new(users(:one).attributes.except("id"))
    new_user.email = "invalid"
    new_user.save
    assert new_user.invalid?
    assert_equal [ "is invalid" ], new_user.errors[:email]
  end

  test "should not save user with short password" do
    new_user = User.new(users(:one).attributes.except("id"))
    new_user.password = "12345"
    new_user.save
    assert new_user.invalid?
    assert_equal [ "is too short (minimum is 6 characters)" ], new_user.errors[:password]
  end

  test "should not save user with long password" do
    new_user = User.new(users(:one).attributes.except("id"))
    new_user.password = "123456789012345678901"
    new_user.save
    assert new_user.invalid?
    assert_equal [ "is too long (maximum is 20 characters)" ], new_user.errors[:password]
  end

  test "should not save user with duplicate email" do
    new_user = User.new(users(:one).attributes.except("id"))
    new_user.email = users(:two).email
    new_user.save
    assert new_user.invalid?
    assert_equal [ "has already been taken" ], new_user.errors[:email]
  end

  test "should not save user with duplicate username" do
    new_user = User.new(users(:one).attributes.except("id"))
    new_user.email += ".new"
    new_user.username = users(:two).username
    new_user.password = "123456"
    new_user.save
    assert new_user.invalid?
    assert_equal [ "has already been taken" ], new_user.errors[:username]
  end

  test "should save user's date_of_birth as blank with invalid value set" do
    new_user = User.new(users(:one).attributes.except("id"))
    new_user.email += ".new"
    new_user.username += ".new"
    new_user.password = "123456"
    new_user.date_of_birth = "invalid"
    new_user.save
    assert new_user.valid?
  end

  test "should not save user's date_of_birth with date in the future" do
    new_user = User.new(users(:one).attributes.except("id"))
    new_user.email += ".new"
    new_user.username += ".new"
    new_user.password = "123456"
    new_user.date_of_birth = "invalid"
    new_user.date_of_birth = Time.now.tomorrow
    new_user.save
    assert new_user.invalid?
    assert_equal [ "must be at least 15 years old" ], new_user.errors[:date_of_birth]
  end

  test "should not save user with invalid role" do
    new_user = User.new(users(:one).attributes.except("id"))
    new_user.email += ".new"
    new_user.username += ".new"
    new_user.password = "123456"
    assert_raises ArgumentError, "is not a valid role" do
      new_user.role = "invalid"
    end
  end

  test "count of users should be 5" do
    assert_equal 5, User.count
  end
end
