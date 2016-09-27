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

  def save
    columns = {}
    self.instance_variables.each do |var|
      columns[var[1..-1]] = self.instance_variable_get(var) unless var == :@id
    end

    if @id
      update(columns)
    else
      insert(columns)
    end
  end

  def insert(options = {})
    sql = <<-SQL
      INSERT INTO
        #{self.class::TABLE} (#{options.keys.join(', ')})
      VALUES
        (#{options.keys.map{'?'}.join(', ')})
    SQL

    execute(sql, *options.values)

    options['id'] = QuestionsDatabase.instance.last_insert_row_id
    self.class.new(options)
  end

  def delete
    raise unless @id

    sql = <<-SQL
      DELETE FROM #{self.class::TABLE}
      WHERE id = ?
    SQL

    execute(sql, @id)
  end

  def update(options)
    array = []
    options.keys.each do |key|
      array << "#{key} = ?"
    end

    sql = <<-SQL
      UPDATE
        #{self.class::TABLE}
      SET
        #{array.join(", ")}
      WHERE
        id = ?
    SQL

    values = options.values + [@id]

    execute(sql, *values)

    options['id'] = @id
    self.class.new(options)
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
