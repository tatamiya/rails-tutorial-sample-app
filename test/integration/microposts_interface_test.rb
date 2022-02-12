require "test_helper"

class MicropostsInterfaceTest < ActionDispatch::IntegrationTest

  def setup
    @user = users(:michael)
  end

  test "micropost interface" do
    log_in_as(@user)
    get root_path
    assert_select 'div.pagination'

    # Invalid submission
    assert_no_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: "" } }
    end
    assert_select 'div#error_explanation'
    assert_select 'a[href=?]', '/?page=2'

    # Valid submission
    content = "This micropost really ties the room together"
    assert_difference 'Micropost.count' do
      post microposts_path, params: { micropost: { content: content }}
    end
    assert_redirected_to root_url
    follow_redirect!
    assert_match content, response.body

  end
  # test "the truth" do
  #   assert true
  # end
end
