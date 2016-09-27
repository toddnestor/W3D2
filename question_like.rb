require_relative 'model'

class QuestionLike < Model
  attr_accessor :question_id, :user_id

  TABLE = 'question_likes'

  def initialize(options={})
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end
end
