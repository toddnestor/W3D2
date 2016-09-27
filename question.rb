require_relative "requires"

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

  def followers
    Question.followers_for_question_id(@id)
  end

  def most_followed(n = 5)
    QuestionFollow.most_followed_questions(n)
  end
end
