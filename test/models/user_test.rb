require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @saved_user = User.create(name: "Example Saved User", email: "saveduser@example.com", password: "foobar", password_confirmation: "foobar")
    @user = User.new(name: "Example User", email: "user@example.com", password: "foobar", password_confirmation: "foobar")
  end

  test "should be valid" do
    assert @user.valid?
  end

  test "should be invalid if it has empty name" do
    @user.name = ""
    assert_not @user.valid?
  end

  test "should be invalid if its name is more than 50 chars" do
    @user.name = "a" * 51
    assert_not @user.valid?
  end

  test "should be invalid if it has empty email" do
    @user.email = ""
    assert_not @user.valid?
  end

  test "should be invalid if its email has more than 255 chars" do
    @user.email = "a" * 244 + "@example.com"
    assert_not @user.valid?
  end

  test "should be valid if its email is in valid email format" do
    valid_emails = %w[kend654@gmail.com permagate@gmail.com johnnyawesome.tc@hotmail.com]
    valid_emails.each do |valid_email|
      @user.email = valid_email
      assert @user.valid?, "#{valid_email.inspect} should be valid"
    end
  end

  test "should be valid if its email is in invalid email format" do
    invalid_emails = %w[kend654 kend654@ kend654@gmail kend654@gmail. @gmail.com gmail.com .com kend654@gmail,com kend654.gmail.com kend654@gm+ail.com 
                        kend654@gmail..com]
    invalid_emails.each do |invalid_email|
      @user.email = invalid_email
      assert_not @user.valid?, "#{invalid_email.inspect} should be invalid"
    end
  end

  test "should be invalid if its email already exists in database" do
    @user = @saved_user.dup
    assert_not @user.valid?
  end

  test "should be invalid if its email already exists in database (case-sensitive)" do
    @user = @saved_user.dup
    @user.email.upcase!
    assert_not @user.valid?
  end

  test "should be valid if its email is stored in lower-case chars" do
    @user.email = "HaHaHa@gmail.com"
    @user.save
    assert_equal @user.reload.email, "hahaha@gmail.com"
  end

  test "should be invalid if its password has less than 6 chars" do
    @user.password = @user.password_confirmation = "a" * 5;
    assert_not @user.valid?
  end

  test "should return false when calling authenticated? for a user with nil digest" do
    assert_not @user.authenticated?(:remember, '')
  end

  test "associated microposts should be destroyed" do
    @saved_user.microposts.create! content: "Lorem ipsum"
    assert_difference 'Micropost.count', -1 do
      @saved_user.destroy
    end
  end

  test "should follow and unfollow a user" do
    johnnyawesome = users(:johnnyawesome)
    zeus  = users(:zeus)
    assert_not johnnyawesome.following?(zeus)
    johnnyawesome.follow(zeus)
    assert johnnyawesome.following?(zeus)
    assert zeus.followers.include?(johnnyawesome)
    johnnyawesome.unfollow(zeus)
    assert_not johnnyawesome.following?(zeus)
  end

  test "feed should have the right posts" do
    johnnyawesome = users(:johnnyawesome)
    zeus          = users(:zeus)
    sissysilly    = users(:sissysilly)
    # Posts from followed user
    sissysilly.microposts.each do |post_following|
      assert johnnyawesome.feed.include?(post_following)
    end
    # Posts from self
    johnnyawesome.microposts.each do |post_self|
      assert johnnyawesome.feed.include?(post_self)
    end
    # Posts from unfollowed user
    zeus.microposts.each do |post_unfollowed|
      assert_not johnnyawesome.feed.include?(post_unfollowed)
    end
  end
end
