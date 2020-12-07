def json
  JSON.parse(response.body)
end

def change_poll_question_content(obj, new_value)
  obj[:poll_questions_attributes].map! do |item|
    item[:content] = new_value
    item
  end
end

def change_poll_answer_content(obj, new_value)
  obj[:poll_questions_attributes].map! do |item|
    item[:poll_answers_attributes].map! do |answer|
      answer[:content] = new_value
      answer
    end
    item
  end
end
