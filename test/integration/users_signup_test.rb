require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @valid_user = { name: "Johnny Awesome",
                    email: "johnnyawesome.tc@gmail.com",
                    password: "foobar",
                    password_confirmation: "foobar" }
  end

  test "should create new user when there are no invalid signup data" do
    get signup_path
    assert_difference 'User.count', 1 do
      post_via_redirect users_path, user: @valid_user
    end
    assert_template 'users/show'
    assert flash[:success]
  end

  test "should show 1 error when name is empty" do
    @valid_user[:name] = ""
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: @valid_user
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation ul li', 1
  end

  test "should show 1 error when name has more than 50 chars" do
    @valid_user[:name] = "a" * 51
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: @valid_user
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation ul li', 1
  end

  test "should show 2 errors when email is empty" do
    @valid_user[:email] = ""
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: @valid_user
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation ul li', 2
  end

  test "should show 1 error when email has more than 255 chars" do
    @valid_user[:email] = "a" * 244 + "@example.com"
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: @valid_user
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation ul li', 1
  end

  test "should show 1 error when email is in invalid format" do
    @valid_user[:email] = "a" * 10
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: @valid_user
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation ul li', 1
  end

  test "should show 2 errors when password is empty" do
    @valid_user[:password] = ""
    @valid_user[:password_confirmation] = ""
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: @valid_user
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation ul li', 2
  end

  test "should show 1 error when password has less than 6 chars" do
    @valid_user[:password] = "a" * 5
    @valid_user[:password_confirmation] = "a" * 5
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: @valid_user
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation ul li', 1
  end

  test "should show 1 error when password doesn\'t match password confirmation" do
    @valid_user[:password] = "a" * 6
    @valid_user[:password_confirmation] = "a" * 7
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, user: @valid_user
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation ul li', 1
  end
end
