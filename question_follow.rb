require_relative "requires"

class QuestionFollow < Model
  attr_accessor :question_id, :user_id

  TABLE = 'question_follows'

  def initialize(options={})
    @id = options['id']
    @question_id = options['question_id']
    @user_id = options['user_id']
  end

  def self.followers_for_question_id(id)
    sql = <<-SQL
      SELECT
        users.*
      FROM
        question_follows
        JOIN users
          ON question_follows.user_id = users.id
      WHERE
        question_follows.question_id = ?
    SQL

    data = Model.execute(sql, id)
    data.map { |el| User.new(el) }
  end

  def self.followed_questions_for_user_id(id)
    sql = <<-SQL
      SELECT
        questions.*
      FROM
        question_follows
        JOIN questions
          ON question_follows.question_id = questions.id
      WHERE
        question_follows.user_id = ?
    SQL

    data = Model.execute(sql, id)
    data.map { |el| Question.new(el) }
  end

  def self.most_followed_questions(n = 5)
    sql = <<-SQL
      SELECT
        questions.*
      FROM
        questions
        LEFT JOIN question_follows
          ON question_follows.question_id = questions.id
      GROUP BY
        questions.id
      ORDER BY
        COUNT(question_follows.user_id) DESC
      LIMIT
        ?
    SQL

    data = Model.execute(sql, n)
    data.map { |el| Question.new(el) }
  end
end
