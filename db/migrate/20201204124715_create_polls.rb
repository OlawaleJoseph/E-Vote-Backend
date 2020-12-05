class CreatePolls < ActiveRecord::Migration[6.0]
  def change
    create_table :polls do |t|
      t.string :title, null: false
      t.text :info, null: false
      t.string :img_url, null: false
      t.boolean :restricted, null: false
      t.datetime :start_date, null: false
      t.datetime :end_date, null: false
      t.integer :host_id, class_name: 'User'

      t.timestamps
    end
    add_index :polls, :host_id
  end
end
