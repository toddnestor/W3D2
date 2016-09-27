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

  def self.find_by_author_id(id)
    self.find_by_user_id(id)
  end

  def author
    User.find_by_id(@user_id).first
  end

  def replies
    Reply.find_by_question_id(@id)
  end

  def followers
    Question.followers_for_question_id(@id)
  end

  def most_followed(n = 5)
    QuestionFollow.most_followed_questions(n)
  end

  def most_followed(n = 5)
    QuestionLike.most_liked_questions(n)
  end

  def likers
    QuestionLike.likers_for_question_id(@id)
  end

  def num_likes
    QuestionLike.num_likes_for_question_id(@id)
  end
end
