require 'test_helper'

class MicropostTest < ActiveSupport::TestCase
  def setup
    @user = users(:test)
    @micropost = @user.microposts.build(content: "Lorum Ipsum")
  end

  test 'should be valid' do
    assert @micropost.valid?
  end
  
  test 'user id should be present' do
    @micropost.user_id = nil
    assert_not @micropost.valid?
  end

  test 'content may not be blank' do
    @micropost.content = ' '
    assert_not @micropost.valid?
  end

  test 'content may not exceed 140 characters' do
    @micropost.content = 'a' * 141
    assert_not @micropost.valid?
  end
  test "should get most recent" do
    assert_equal microposts(:four), Micropost.first
    assert_equal microposts(:one), Micropost.last
  end
end
