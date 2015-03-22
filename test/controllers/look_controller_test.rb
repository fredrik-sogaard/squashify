require 'test_helper'

class LookControllerTest < ActionController::TestCase
  test "should get index" do
    get :index
    assert_response :success
  end

end
