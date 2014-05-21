class ModifyStations < ActiveRecord::Migration
  def change

    remove_column :stations, :user_id
    change_table :stations do |t|
      t.integer :user_id
    end

  end
end
