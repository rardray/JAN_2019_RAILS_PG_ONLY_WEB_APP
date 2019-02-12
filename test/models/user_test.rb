require 'test_helper'

class UserTest < ActiveSupport::TestCase
  def setup
    @user = User.new(name: 'Example User', email: 'user@example.com', password: 'fooBar0', password_confirmation: 'fooBar0')
  end
  test 'should be valid' do
    assert @user.valid?
  end

  test 'name should be present' do
    @user.name = 'a' * 51
    assert_not @user.valid?
  end
  test 'email should be present' do
    @user.email = 'a' * 244 + '@example.com'
    assert_not @user.valid?
  end

  test 'email validation should accept valid addresses' do
    valid_addresses = %w[user@example.com USER@foo.com A_US_ER@foo.bar.org first.last@foo.jp alice+bob@baz.cn]
    valid_addresses.each do |valid_address|
      @user.email = valid_address
      assert @user.valid?, "#{valid_address.inspect} should be valid"
    end
  end
  test 'email validation should reject invalid addresses' do
    invalid_addresses = %w[user@example,com user_at_foo.org user.name@example. foo@bar_baz.com foo@bar+baz.com foo@bar..com]
    invalid_addresses.each do |invalid_address|
      @user.email = invalid_address
      assert_not @user.valid?, "#{invalid_address.inspect} should be invalid"
    end
  end
  test 'user email should be unique' do
    duplicate_user = @user.dup
    duplicate_user.email = @user.email.upcase
    @user.save
    assert_not duplicate_user.valid?
  end
  test 'email should be lowercase' do
    m_case_email = 'FoOBar@TurD.com'
    @user.email = m_case_email
    @user.save
    assert_equal m_case_email.downcase, @user.reload.email
  end
  test 'password should not be blank' do
    @user.password = @user.password_confirmation = ' ' * 6
    assert_not @user.valid?
  end
  test 'password should have minimum length' do
    @user.password = @user.password_confirmation = 'a' * 5
    assert_not @user.valid?
  end
  test 'valid passwords test' do
    valid_password = %w[Dominion1234 axeToGrind5 weensOfB12 hellOSh8 xxxXX00]
    valid_password.each do |p|
      @user.password = @user.password_confirmation = p
      assert @user.valid?, "#{p.inspect} is invalid"
    end
  end
  test 'invalid password' do
    invalid_password = %w[password PASSWORD PASSW0RD 0000000]
    invalid_password.each do |i|
      @user.password = @user.password_confirmation = i
      assert_not @user.valid?, "#{i.inspect} is not valid"
    end
  end
  test 'authenticated? should return false for nil digest' do
    assert_not @user.authenticated?(:remember, '')
  end
end
