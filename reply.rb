require_relative "requires"

class Reply < Model
  attr_accessor :body, :parent, :user_id, :question_id

  TABLE = 'replies'

  def initialize(options={})
    @id = options['id']
    @body = options['body']
    @parent = options['parent']
    @user_id = options['user_id']
    @question_id = options['question_id']
  end

  def author
    User.find_by_id(@user_id).first
  end

  def question
    Question.find_by_id(@question_id).first
  end

  def parent_reply
    return nil unless @parent
    Reply.find_by_id(@parent).first
  end

  def child_replies
    Reply.find_by_parent(@id)
  end

end
