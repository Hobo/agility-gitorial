require 'test_helper'

class UserTest < ActiveSupport::TestCase
  test "the truth" do
    @user = create :user
    assert_equal "Test User", @user.name
  end
end
