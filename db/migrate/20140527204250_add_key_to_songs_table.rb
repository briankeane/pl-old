class AddKeyToSongsTable < ActiveRecord::Migration
  def change
    add_column :audio_blocks, :key, :string
  end
end
