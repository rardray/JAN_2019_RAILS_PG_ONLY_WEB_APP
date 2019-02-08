require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test)
  end
  test 'unsuccessful edit' do
    log_in_as(@user)
    get edit_user_path(@user)
    assert_template 'users/edit'
    patch user_path(@user), params: { user: { name: '',
                                              email: 'fo@invalid',
                                              password: 'ffo',
                                              password_confirmation: 'bar' }
                                            }
    assert_template 'users/edit'
    assert_select 'div.alert'
  end

  test 'successful edit with friendly fowarding' do
    get edit_user_path(@user)
    assert_not !session[:forwarding_url]
    log_in_as(@user)
    assert_redirected_to edit_user_url(@user)
    name = 'Foo Bar'
    email = 'email@email.com'
    patch user_path(@user), params: { user: { name: name,
                                              email: email,
                                              password: '',
                                              password_confirmation: '' }
                                            }
    assert_not flash.empty?
    assert_redirected_to @user
    @user.reload
    assert_nil session[:forwarding_url]
    assert_equal name, @user.name
    assert_equal email, @user.email
  end
  
end
