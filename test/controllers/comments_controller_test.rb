require 'test_helper'

class CommentsControllerTest < ActionDispatch::IntegrationTest
  def setup
    @comment = comments(:uno)
  end
  test 'should redirect create when not logged in' do
    assert_no_difference 'Comment.count' do
      post comments_path params: {content: 'wordup'}
    end
    assert_redirected_to login_path
  end
  test 'should redirect destroy when not logged in' do
    assert_no_difference 'Comment.count' do
      delete comment_path(@comment)
    end
    assert_redirected_to login_path
  end

  test 'should redirect when delete with incorrect user' do
    log_in_as(users(:test))
    comment = comments(:dos)
    assert_no_difference 'Comment.count' do
      delete comment_path(comment)
    end
    assert_redirected_to root_url
  end
  test 'should delete when correct user' do
    log_in_as(users(:test))
    assert_difference 'Comment.count', -1 do
      delete comment_path(@comment)
    end
  end
end
