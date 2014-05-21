class MakeAudioBlocksPolymorphic < ActiveRecord::Migration
  def change
    remove_column :spins, :audio_block

    change_table :spins do |t|
      t.integer :audio_block_id
      t.string :audio_block_type
    end
  end
end
