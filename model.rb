require_relative 'questions_database'

class Model
  attr_reader :id

  def method_missing(method, *args)
    method_name = method.to_s

    if method_name.start_with?('find_by_')
      column = method_name[8..-1]

      data = execute(<<-SQL, args[0])
      SELECT
        *
      FROM
        #{self.class::TABLE}
      WHERE
        #{column} = ?
      SQL

      data.map { |el| self.class.new(el) }
    else
      super
    end
  end

  def all
    data = execute(<<-SQL)
    SELECT
      *
    FROM
      #{self.class::TABLE}

    SQL

    data.map { |el| self.class.new(el) }
  end

  def execute(*args)
    QuestionsDatabase.instance.execute(*args)
  end

  def self.execute(*args)
    QuestionsDatabase.instance.execute(*args)
  end

  # def find_by_id(id)
  #   data = execute(<<-SQL, id)
  #   SELECT
  #     *
  #   FROM
  #     #{self.class::TABLE}
  #   WHERE
  #     id = ?
  #   SQL
  #
  #   self.class.new(data.first)
  # end
end
