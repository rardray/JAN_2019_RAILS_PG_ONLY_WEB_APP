require 'test_helper'

class PasswordResetsTest < ActionDispatch::IntegrationTest
  def setup
     ActionMailer::Base.deliveries.clear
    @user = users(:test)
  end

  test 'password resets' do
    get new_password_reset_path
    assert_template 'password_resets/new'
    post password_resets_path, params: {password_reset: {email: ''}}
    assert_not flash.empty?
    assert_template 'password_resets/new'
    #valid email
    post password_resets_path, params: {password_reset: {email: @user.email}}
    assert_not_equal @user.reset_digest, @user.reload.reset_digest
    assert_equal 1, ActionMailer::Base.deliveries.size
    assert_not flash.empty?
    assert_redirected_to root_url
    #reset form
    user = assigns(:user)
    # wrong email
    get edit_password_reset_path(user.reset_token, email: '')
    assert_redirected_to root_url
    # inactive user
    user.toggle!(:activated)
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_redirected_to root_url
    user.toggle!(:activated)
    # wrong token
    get edit_password_reset_path('wrong token',  email: user.email)
    assert_redirected_to root_url
    # correct
    get edit_password_reset_path(user.reset_token, email: user.email)
    assert_template 'password_resets/edit'
    assert_select "input[name=email][type=hidden][value=?]", user.email
    # invalid password & confirmation
    patch password_reset_path(user.reset_token), params: {email: user.email, user: {password: '', password_confirmation: ''}}
    assert_select 'div#error_explanation'
    # valid password
    patch password_reset_path(user.reset_token), params: {email: user.email, user: {password: "Password1", password_confirmation: "Password1"}}
    assert is_logged_in?
    assert_not flash.empty?
    assert_redirected_to user
    assert user.reload.reset_digest.nil?
  end

  test 'check password token expiration' do
    get new_password_reset_path
    post password_resets_path, params: {password_reset: {email: @user.email } }
    @user = assigns(:user)
    @user.update_attribute(:reset_sent_at, 3.hours.ago)
    patch password_reset_path(@user.reset_token),
      params: { email: @user.email,
                user: { password: 'Password1', password_confirmation: 'Password1'}}
    assert_response :redirect
    follow_redirect!
    assert_match /expired/i, response.body
  end
end
