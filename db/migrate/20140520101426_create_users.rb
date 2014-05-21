class CreateUsers < ActiveRecord::Migration
  def change
    # TODO
    create_table :users do |t|
      t.string :twitter
      t.string :email
      t.string :password_digest

      t.timestamps
    end
  end
end
