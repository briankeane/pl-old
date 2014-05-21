class CreateAudioBlocks < ActiveRecord::Migration
  def change
    create_table :audio_blocks do |t|
      t.integer :duration
      t.string :audio_id
      t.string :title
      t.string :artist
      t.string :album
      t.integer :sing_start
      t.integer :sing_end
      t.string :type
    end
  end
end
