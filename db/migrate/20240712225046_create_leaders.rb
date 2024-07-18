class CreateLeaders < ActiveRecord::Migration[7.0]
  def change
    create_table :leaders do |t|
      t.string :name

      t.timestamps
    end
  end
end
