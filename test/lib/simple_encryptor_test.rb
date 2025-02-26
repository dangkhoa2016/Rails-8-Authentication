require "test_helper"
require "simple_encryptor"

class SimpleEncryptorTest < ActiveSupport::TestCase
  test "encrypts and decrypts a string" do
    encrypted = SimpleEncryptor.encrypt("hello")
    assert_equal "hello", SimpleEncryptor.decrypt(encrypted)
  end
end
