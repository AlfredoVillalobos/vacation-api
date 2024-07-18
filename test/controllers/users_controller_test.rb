require "test_helper"

class UsersControllerTest < ActionDispatch::IntegrationTest
  setup do
    @user = User.create(name: "Userio test", email: "ususariotest1@gmail.com")
    @leader = Leader.create(name: "Leader test")
    @user_with_vacation = User.create(
      name: "Userio test", 
      email: "ususariotest1@gmail.com",
      leader_id: @leader.id,
      vacations_attributes: [
        { start_date: "2021-01-01", end_date: "2021-01-15", status: :approved },
        { start_date: "2022-02-01", end_date: "2022-02-15", status: :approved },
        { start_date: "2023-03-01", end_date: "2023-03-15", status: :approved }
      ]
    )
    @users_path = "/v1/users"
    @headers = { "Authorization" => "Bearer #{ENV['JWT_TEST']}" }
    @header_invalid = { "Authorization" => "Bearer 123" }
    @header_without_token = { "Authorization" => "Bearer " }
  end

  # when the token is valid
  test "should get index" do
    get @users_path, headers: @headers, as: :json
    assert_response :success
  end

  test "should create user" do
    # the result expected is 2 because created the current user
    assert_difference('User.count', 2) do
      post @users_path, headers: @headers, params: { 
        user: { 
          name: "Userio test", 
          email: "usuariotest1@gmail.com",
        } 
      }, as: :json
    end

    assert_response :created
  end

  test "should show user" do
    get "#{@users_path}/#{@user.id.to_s}", headers: @headers, as: :json
    assert_response :success
  end

  test "should update user" do
    patch "#{@users_path}/#{@user.id.to_s}", headers: @headers, params: { 
      user: { name: "Userio test update" } 
    }, as: :json
    assert_response :success
  end

  test "should destroy user" do
    # the result expected is 0 because the current user is not deleted
    assert_difference("User.count", 0) do
      delete "#{@users_path}/#{@user.id.to_s}", headers: @headers, as: :json
    end

    assert_response :no_content
  end

  test "should not return the vacation per year of a user if he has not vacation" do
    get "#{@users_path}/vacation_per_year/#{@user.id}", headers: @headers, as: :json

    assert_response :success
    result = JSON.parse(@response.body)
    assert_equal({"vacation_per_year" => {}}, result)
  end

  test "should return the quantity of days of vacations per year of a use if he has vacation" do
    get "#{@users_path}/vacation_per_year/#{@user_with_vacation.id}", headers: @headers, as: :json

    assert_response :success
    result = JSON.parse(@response.body)
    assert_equal({"vacation_per_year" => {"2021" => 15, "2022" => 15, "2023" => 15}}, result)
  end

  test "should return error if the user does not exist" do
    # vacation per year
    get "#{@users_path}/vacation_per_year/0", headers: @headers, as: :json
    assert_response :not_found


    # show
    get "#{@users_path}/0", headers: @headers, as: :json
    assert_response :not_found
  end

  test "should return the users filtered" do
    # return users by leader
    get "#{@users_path}/query_scope?leader_id=#{@leader.id}", headers: @headers, as: :json
    assert_response :success

    # return users who have vacation from a start date
    get "#{@users_path}/query_scope?start_date=2021-01-01", headers: @headers, as: :json
    assert_response :success

    # return users who finish vacation from an end date
    get "#{@users_path}/query_scope?end_date=2021-01-15", headers: @headers, as: :json
    assert_response :success

    # return users who will take vacation from a start date
    get "#{@users_path}/query_scope?vacation_to_take=2021-01-01", headers: @headers, as: :json
    assert_response :success

    # return users who took vacation from a start date
    get "#{@users_path}/query_scope?vacation_took=2021-01-01", headers: @headers, as: :json
    assert_response :success

    # should not return users if params does not exist
    get "#{@users_path}/query_scope", headers: @headers, as: :json
    assert_response :unprocessable_entity
  end
  # <--->

  # when the token exist but is invalid
  test "should no get index if token is invalid" do
    get @users_path, headers: @header_invalid, as: :json
    assert_response :unprocessable_entity
  end
  # <--->

  # when the token is not present
  test "should no get index if token is not present" do
    get @users_path, headers: @header_without_token, as: :json
    assert_response :unauthorized
  end
  # <--->
end
