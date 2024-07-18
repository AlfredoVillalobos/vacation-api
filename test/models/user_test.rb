require "test_helper"

class UserTest < ActiveSupport::TestCase
  test "should saver user with name and email" do
    user = User.new name: "test", email: "test1@gmail.com"
    assert user.save
  end

  test "should not save user without name" do
    user = User.new email: "test1@mail.com"
    assert_not user.save
  end

  test "should not save user without email" do
    user = User.new name: "test"
    assert_not user.save
  end

  test "should not save user with invalid email" do
    user = User.new name: "test", email: "invalid"
    assert_not user.save
  end

  test "should return the quantity of days of vacations per year" do
    user = User.create name: "test", email: "test1@gmail.com"
    vacation_data = [ {start_date: "2021-01-01", end_date: "2021-01-15", status: :approved},
                      {start_date: "2022-02-01", end_date: "2022-02-15", status: :approved},
                      {start_date: "2023-03-01", end_date: "2023-03-15", status: :approved}
                    ]
    vacation_data.each do |data|
      vacation = Vacation.create(start_date: data[:start_date], end_date: data[:end_date], status: data[:status])
      user.vacations << vacation
    end

    assert_equal({2021 => 15, 2022 => 15, 2023 => 15}, user.vacation_had_days_per_year)
  end
end
