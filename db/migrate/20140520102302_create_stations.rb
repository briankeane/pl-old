class CreateStations < ActiveRecord::Migration
  def change
    create_table :stations do |t|
      t.string :user_id
      t.integer :seconds_of_commercial_per_hour

      t.timestamps
    end
  end
end
