class CreatePollQuestions < ActiveRecord::Migration[6.0]
  def change
    create_table :poll_questions do |t|
      t.string :content, null: false
      t.integer :poll_id, nul: false, foreign_key: true

      t.timestamps
    end
    add_index :poll_questions, :poll_id
  end
end
