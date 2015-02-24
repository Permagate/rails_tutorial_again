require 'test_helper'

class SiteLayoutTest < ActionDispatch::IntegrationTest
  # test "the truth" do
  #   assert true
  # end
  def setup
    @admin = users(:johnnyawesome)
    @non_admin = users(:sissysilly)
  end

  test "home links" do
    get root_path
    assert_template 'static_pages/home'
    assert_select "a[href=?]", root_path, count: 2
    assert_select "a[href=?]", help_path
    assert_select "a[href=?]", about_path
    assert_select "a[href=?]", contact_path  
  end

  test "signup title" do
    get signup_path
    assert_template "users/new"
    assert_select "title", full_title("Sign up")
  end
  
  test "should show login link in homepage when user is not logged in" do
    get root_path
    assert_select "a[href=?]", login_path
  end

  test "should show user-related and logout links in homepage when user is logged in" do
    log_in_as @admin
    get root_path
    assert_select "a[href=?]", user_path(@admin.id)
    assert_select "a[href=?]", edit_user_path(@admin.id)
    assert_select "a[href=?]", users_path
    assert_select "a[href=?]", logout_path
  end

  test "should not show delete link in users page when user is not logged in as admin" do
    log_in_as @non_admin
    get users_path
    assert_select "a[data-method=delete][href~=?]", users_path, false
  end

  test "should show delete link in users page when user is logged in as admin" do
    log_in_as @admin
    get users_path
    assert_select "a[data-method=delete][href*=?]", users_path, true
  end
end
