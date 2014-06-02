class AddTwitterUidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :twitter_uid, :string
  end
end
