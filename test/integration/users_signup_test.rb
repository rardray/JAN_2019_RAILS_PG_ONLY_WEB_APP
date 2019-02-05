require 'test_helper'

class UsersSignupTest < ActionDispatch::IntegrationTest
  test 'invalid signup information' do
    get signup_path
    assert_no_difference 'User.count' do
      post users_path, params: { user:
        {
          name: '', email: 'email@invalid', 
          password: 'foo', password_confirmation: 'bar'
        } }
    end
    assert_template 'users/new'
    assert_select 'div#error_explanation'
    assert_select 'div.alert'
    assert_select 'div.alert-danger'
    assert_select 'form[action="/signup"]'
  end

  test 'valid signup' do
    get signup_path
    assert_difference 'User.count', 1 do
      post users_path, params: { user:
        {
          name: 'Example User', email: 'email@example.com',
          password: 'Password1', password_confirmation: 'Password1'
        } }
    end
    follow_redirect!
    assert_template 'users/show'
    assert_template 'layouts/_flash_message'
    assert is_logged_in?
  end
end
# this test checks that user count remains the same when invalid data posted as well verifies that sends to proper view
