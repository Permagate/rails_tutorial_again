require 'test_helper'

class UsersLoginTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:johnnyawesome)
  end

  # test "the truth" do
  #   assert true
  # end
  test "login with invalid information" do
    get login_path
    post login_path, session: { email: @user.email, password: 'foobar' }
    assert_redirected_to @user
    follow_redirect!
    assert_template 'users/show'
    assert_select "a[href=?]", login_path, count: 0
    assert_select "a[href=?]", logout_path
    assert_select "a[href=?]", user_path(@user)
  end
end
