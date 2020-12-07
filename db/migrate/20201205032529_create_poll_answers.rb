class CreatePollAnswers < ActiveRecord::Migration[6.0]
  def change
    create_table :poll_answers do |t|
      t.string :content, null: false
      t.integer :poll_question_id, null: false, foreign_key: true

      t.timestamps
    end
    add_index :poll_answers, :poll_question_id
  end
end
