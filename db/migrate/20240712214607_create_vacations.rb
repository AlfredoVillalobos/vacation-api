class CreateVacations < ActiveRecord::Migration[7.0]
  def change
    create_table :vacations do |t|
      t.belongs_to :user, null: false, foreign_key: true
      t.date :start_date
      t.date :end_date
      t.integer :status, null: false, default: 0

      t.timestamps
    end
  end
end
