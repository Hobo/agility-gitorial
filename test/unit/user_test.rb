require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # Replace this with your real tests.
  test "the truth" do
    @user = create :user
    assert_equal "Test User", @user.name
  end
end
