require "test_helper"

class VacationTest < ActiveSupport::TestCase
  user = User.create(name: "test vacation", email: "test1@gmail.com")
  
  test "should save vacation with start_date, end_date and user" do
    vacation = Vacation.create(start_date: "2021-01-01", end_date: "2021-01-15", user_id: user.id)
    
    assert vacation.save
  end

  test "should not save vacation without start_date and end_date" do
    vacation = Vacation.create(end_date: "2021-01-15", user_id: user.id)
    assert_not vacation.save

    vacation = Vacation.create(start_date: "2021-01-01", user_id: user.id)
    assert_not vacation.save
  end

  test "should not save vacation without user" do
    vacation = Vacation.create(start_date: "2021-01-01", end_date: "2021-01-15")
    assert_not vacation.save
  end

  test "should return the quantity of days of vacation" do
    vacation = Vacation.create(start_date: "2021-01-01", end_date: "2021-01-15", user_id: user.id)
    assert_equal 15, vacation.days
  end

  test "should return the status of vacation" do
    vacation = Vacation.create(start_date: "2021-01-01", end_date: "2021-01-15", user_id: user.id)
    assert_equal "pending", vacation.status

    vacation.approved!
    assert_equal "approved", vacation.status

    vacation.rejected!
    assert_equal "rejected", vacation.status
  end

  test "should return the translation of status" do
    vacation = Vacation.create(start_date: "2021-01-01", end_date: "2021-01-15", user_id: user.id)
    assert_equal "Pendiente", vacation.status_label

    vacation.approved!
    assert_equal "Aprobado", vacation.status_label

    vacation.rejected!
    assert_equal "Rechazado", vacation.status_label
  end
end
