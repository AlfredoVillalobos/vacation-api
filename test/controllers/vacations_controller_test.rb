require "test_helper"

class VacationsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.last
    @vacation = Vacation.create(start_date: "2024-05-01", end_date: "2024-05-10", user_id: @user.id)
    @vacations_path = "/v1/vacations"
    @headers = { "Authorization" => "Bearer #{ENV['JWT_TEST']}" }
    @header_invalid = { "Authorization" => "Bearer 123" }
    @header_without_token = { "Authorization" => "Bearer " }
  end

  # when the token is valid
  test "should get index" do
    get @vacations_path, headers: @headers, as: :json
    assert_response :success
  end

  test "should create vacation" do
    assert_difference("Vacation.count") do
      post @vacations_path, headers: @headers, params: { 
        vacation: { 
          start_date: "2024-05-01", 
          end_date: "2024-05-10", 
          user_id: @user.id 
        } 
      }, as: :json
    end

    assert_response :created
  end

  test "should show vacation" do
    get "#{@vacations_path}/#{@vacation.id.to_s}", headers: @headers, as: :json
    assert_response :success
  end

  test "should not show vacation if not found" do
    get "#{@vacations_path}/0", headers: @headers, as: :json
    assert_response :not_found
  end

  test "should update vacation" do
    patch "#{@vacations_path}/#{@vacation.id.to_s}", headers: @headers, params: { 
      vacation: { 
        start_date: "2024-05-15", 
        end_date: "2024-05-30" 
      } 
    }, as: :json
    
    assert_response :success
  end

  test "should destroy vacation" do
    assert_difference("Vacation.count", -1) do
      delete "#{@vacations_path}/#{@vacation.id.to_s}", headers: @headers, as: :json
    end

    assert_response :no_content
  end

  test "should get vacations have by user" do
    get "#{@vacations_path}/have_by_user?user_id=#{@user.id}", headers: @headers, as: :json

    assert_response :success
    result = JSON.parse(@response.body)
    assert_equal result, result["vacations"].size == 0 ? { "vacations" => [] } : { "vacations" => result["vacations"] }
  end

  test "should get vacations had by user" do
    get "#{@vacations_path}/had_by_user?user_id=#{@user.id}", headers: @headers, as: :json

    assert_response :success
    result = JSON.parse(@response.body)
    assert_equal(result["vacations"].size == 0 ? { "vacations" => [] } : { "vacations" => result["vacations"] }, result)
  end
  # <--->

  # when the token exist but is invalid
  test "should no get index if token is invalid" do
    get @vacations_path, headers: @header_invalid, as: :json
    assert_response :unprocessable_entity
  end
  # <--->
  
  # when the token does not exist
  test "should no get index if token is not present" do
    get @vacations_path, headers: @header_without_token, as: :json
    assert_response :unauthorized
  end
  # <--->
end
