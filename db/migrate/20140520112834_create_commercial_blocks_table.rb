class CreateCommercialBlocksTable < ActiveRecord::Migration
  def change
    create_table :commercial_blocks do |t|
      t.integer :duration
      t.datetime :played_at
    end
  end
end
