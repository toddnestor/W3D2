require_relative "requires"

class QuestionLike < Model
  attr_accessor :question_id, :user_id

  TABLE = 'question_likes'

  def initialize(options={})
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def self.likers_for_question_id(id)
    sql = <<-SQL
      SELECT
        users.*
      FROM
        question_likes
        JOIN users
          ON question_likes.user_id = users.id
      WHERE
        question_likes.question_id = ?
    SQL

    data = Model.execute(sql, id)
    data.map { |el| User.new(el) }
  end

  def self.num_likes_for_question_id(id)
    sql = <<-SQL
      SELECT
        COUNT(users.id) AS total
      FROM
        question_likes
        JOIN users
          ON question_likes.user_id = users.id
      WHERE
        question_likes.question_id = ?
    SQL

    data = Model.execute(sql, id)
    data.first["total"]
  end


  def self.liked_questions_for_user_id(id)
    sql = <<-SQL
      SELECT
        questions.*
      FROM
        question_likes
        JOIN questions
          ON question_likes.question_id = questions.id
      WHERE
        question_likes.user_id = ?
    SQL

    data = Model.execute(sql, id)
    data.map { |el| Question.new(el) }
  end
end
