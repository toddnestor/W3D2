require_relative "model"
require_relative 'question'
require_relative 'reply'

class User < Model
  attr_accessor :fname, :lname

  TABLE = 'users'

  def initialize(options={})
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end

  def authored_questions
    Question.new.find_by_author_id(@id)
  end

  def authored_replies
    Reply.new.find_by_user_id(@id)
  end
end
