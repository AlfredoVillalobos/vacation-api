require "test_helper"

class LeaderTest < ActiveSupport::TestCase
  test "should save leader with name" do
    leader = Leader.create(name: "test")
    assert leader.save
  end

  test "should not save leader without name" do
    leader = Leader.create(name: nil)
    assert_not leader.save

    leader = Leader.create(name: "")
    assert_not leader.save
  end

  test "should return the quantity of users" do
    leader = Leader.create(name: "test")
    
    users_data = [{name: "test1", email: "test1@gmai.com"},
                  {name: "test1", email: "test1@gmai.com"},
                  {name: "test1", email: "test1@gmai.com"}]

    users_data.each do |data|
      leader.users << User.create(name: data[:name], email: data[:email])
    end

    assert_equal 3, leader.users.count
  end
end
