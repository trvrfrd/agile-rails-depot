require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "shouldn't destroy last user" do
    assert_equal 2, User.count
    User.last.destroy
    assert_equal 1, User.count
    assert_raise User::Error do
      User.last.destroy
    end
    assert_equal 1, User.count
  end
end
