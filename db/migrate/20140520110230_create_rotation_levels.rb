class CreateRotationLevels < ActiveRecord::Migration
  def change
    create_table :rotation_levels do |t|
      t.integer :station_id
      t.integer :song_id
      t.string :level
    end
  end
end
