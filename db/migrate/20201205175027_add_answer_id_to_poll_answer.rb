class AddAnswerIdToPollAnswer < ActiveRecord::Migration[6.0]
  def change
    add_column :poll_answers, :question_id, :integer, class_name: 'PollQuestion', null: true
  end
end
