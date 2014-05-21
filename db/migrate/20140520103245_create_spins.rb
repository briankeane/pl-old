class CreateSpins < ActiveRecord::Migration
  def change
    create_table :spins do |t|
      t.string :audio_block
      t.integer :station_id
      t.integer :current_position
      t.datetime :played_at
    end
  end
end
