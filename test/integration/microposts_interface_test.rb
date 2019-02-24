require 'test_helper'

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test)
    @other_user = users(:test_two)
  end

  test 'micropost interface' do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'
    assert_select 'input[type=file]'
    # invalid submit
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: {content: ''} }
    end
    assert_select 'div#error_explanation'
    # valid submission
    content = "this is a valid submission"
    picture = fixture_file_upload('test/fixtures/rails.png', 'image/png')
    assert_difference 'Micropost.count', 1 do
      post microposts_path, params: {micropost: { content: content, picture: picture} }
    end
    assert @user.microposts.first.picture?
    follow_redirect!
    assert_match content, response.body
    # Delete Post
    assert_select 'a', text: 'delete'
    first_micropost = @user.microposts.paginate(page: 1).first
    assert_difference 'Micropost.count', -1 do
      delete micropost_path(first_micropost)
    end
    get user_path(users(:test_two))
    assert_select 'a', text: 'delete', count: 0
  end
  test 'sidebar microposts count' do
    log_in_as(@user)
    get root_path
    assert_match "#{@user.microposts.count} microposts", response.body
    other_user = users(:malory)
    log_in_as other_user
    get root_path
    assert_match "0 microposts", response.body
    other_user.microposts.create!(content: "a micropost")
    get root_path
    assert_match "#{other_user.microposts.count} micropost", response.body
  end
end
