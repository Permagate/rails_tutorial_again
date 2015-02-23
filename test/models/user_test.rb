require 'test_helper'

class UserTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
  def setup
    @saved_user = User.create(name: "Example Saved User", email: "saveduser@example.com")
    @user = User.new(name: "Example User", email: "user@example.com")
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
end
