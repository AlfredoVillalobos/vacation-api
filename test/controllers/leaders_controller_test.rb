require "test_helper"

class LeadersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @leader = Leader.create(name: "Userio test")
    @leader_url = "/v1/leaders"
    @headers = { "Authorization" => "Bearer #{ENV['JWT_TEST']}" }
    @header_invalid = { "Authorization" => "Bearer 123" }
    @header_without_token = { "Authorization" => "Bearer " }
  end

  # when the token is valid
  test "should get index" do
    get @leader_url, headers: @headers, as: :json
    assert_response :success
  end

  test "should create leader" do
    assert_difference('Leader.count', 1) do
      post @leader_url, headers: @headers, params: { leader: { name: "Usuario test" } }, as: :json
    end
  
    assert_response :created
  end

  test "should show leader" do
    get "#{@leader_url}/#{@leader.id.to_s}", headers: @headers, as: :json
    assert_response :success
  end

  test "should update leader" do
    patch "#{@leader_url}/#{@leader.id.to_s}", headers: @headers, params: { leader: { name: "Userio update test" } }, as: :json
    assert_response :success
  end
  
  test "should destroy leader" do
    assert_difference("Leader.count", -1) do
      delete "#{@leader_url}/#{@leader.id.to_s}", headers: @headers, as: :json
    end

    assert_response :no_content
  end
  # <--->

  # when the token exist but is invalid
  test "should no get index if token is invalid" do
    get @leader_url, headers: @header_invalid, as: :json
    assert_response :unprocessable_entity
  end
  # <--->

  # when the token does not exist
  test "should no get index if token is not present" do
    get @leader_url, headers: @header_without_token, as: :json
    assert_response :unauthorized
  end
  # <--->
end
