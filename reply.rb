require_relative 'model'
require_relative 'user'
require_relative 'question'

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
    User.new.find_by_id(@user_id).first
  end

  def question
    Question.new.find_by_id(@question_id).first
  end

  def parent_reply
    return nil unless @parent
    Reply.new.find_by_id(@parent).first
  end

  def child_replies
    Reply.new.find_by_parent(@id)
  end

end
