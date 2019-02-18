require 'test_helper'

class FollowingTest < ActionDispatch::IntegrationTest
  def setup
    @user = users(:test)
    @other = users(:test_two)
    log_in_as(@user)
  end

  test 'a user the standard way' do
    @user.unfollow(@other)
    assert_difference '@user.following.count', 1 do
      post relationships_path, params: {followed_id: @other.id}
    end
  end

   test 'a user with ajax' do
    @user.unfollow(@other)
    assert_difference '@user.following.count', 1 do
      post relationships_path, xhr: true, params: {followed_id: @other.id}
    end
  end

  test 'follow user standard' do
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship)
    end
  end

    test 'follow user ajax' do
    relationship = @user.active_relationships.find_by(followed_id: @other.id)
    assert_difference '@user.following.count', -1 do
      delete relationship_path(relationship), xhr: true
    end
  end

  test 'following page' do
    get following_user_path(@user)
    assert_not @user.following.empty?
    assert_match @user.following.count.to_s, response.body
    @user.following.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end
  test 'followers page' do
    get followers_user_path(@user)
    assert_not @user.followers.empty?
    assert_match @user.followers.count.to_s, response.body
    @user.followers.each do |user|
      assert_select 'a[href=?]', user_path(user)
    end
  end
end
