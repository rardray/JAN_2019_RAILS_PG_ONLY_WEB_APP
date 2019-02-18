require 'test_helper'

class UsersProfileTest < ActionDispatch::IntegrationTest
  include ApplicationHelper
  def setup
    @user = users(:test)
  end

  test 'profile display' do
    get user_path(@user)
    assert_template 'users/show'
    assert_select 'title', full_title(@user.name)
    assert_select 'h1', text: @user.name
    assert_select 'h1>img.gravatar'
    assert_match @user.microposts.count.to_s, response.body
    assert_select 'div.pagination', count: 1
    @user.microposts.paginate(page: 1).each do |m|
      assert_match m.content, response.body
    end
    log_in_as @user
    assert_redirected_to root_url
    follow_redirect!
    assert_select 'section.stats'
    assert_select 'div.stats'
    assert_select 'a[href=?]', following_user_path(@user), count: 1
  end
end
