require_relative "requires"

class User < Model
  attr_accessor :fname, :lname

  TABLE = 'users'

  def initialize(options={})
    @id = options["id"]
    @fname = options["fname"]
    @lname = options["lname"]
  end

  def authored_questions
    Question.find_by_author_id(@id)
  end

  def authored_replies
    Reply.find_by_user_id(@id)
  end

  def followed_questions
    Question.followed_questions_for_user_id(@id)
  end

  def liked_questions
    QuestionLike.liked_questions_for_user_id(@id)
  end

  def average_karma
    sql = <<-SQL
    SELECT
      (SUM(inner_questions.likes) / CAST( COUNT(inner_questions.id) AS FLOAT)) AS karma
    FROM
      questions
      LEFT JOIN (
        SELECT
          questions.*, COUNT(question_likes.user_id) AS likes
        FROM
          questions
          LEFT JOIN question_likes
            ON question_likes.question_id = questions.id
        WHERE
          questions.user_id = ?
        GROUP BY
          questions.id
        ) AS inner_questions ON questions.id = inner_questions.id
    SQL

    data = execute(sql, @id)

    return data.first['karma'] if data.first['karma']
    0
  end
end
