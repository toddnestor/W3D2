require_relative 'model'
require_relative 'user'
require_relative 'reply'

class Question < Model
  attr_accessor :title, :body, :user_id

  TABLE = 'questions'

  def initialize(options={})
    @id = options['id']
    @title = options['title']
    @body = options['body']
    @user_id = options['user_id']
  end

  def find_by_author_id(id)
    find_by_user_id(id)
  end

  def author
    User.new.find_by_id(@user_id).first
  end

  def replies
    Reply.new.find_by_question_id(@id)
  end
end
