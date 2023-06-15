require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  test "should get userhome" do
    get users_userhome_url
    assert_response :success
  end

  test "should get show" do
    get users_show_url
    assert_response :success
  end

  test "should get edit" do
    get users_edit_url
    assert_response :success
  end

  test "should get movielist" do
    get users_movielist_url
    assert_response :success
  end
end
