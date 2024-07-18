class AddLeaderToUser < ActiveRecord::Migration[7.0]
  def change
    add_reference :users, :leader, null: true
  end
end
