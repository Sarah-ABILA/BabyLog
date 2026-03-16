require "test_helper"

class GesturesControllerTest < ActionDispatch::IntegrationTest
  test "should get index" do
    get gestures_index_url
    assert_response :success
  end
end
