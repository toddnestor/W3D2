require_relative 'questions_database'

class Model
  attr_reader :id

  def self.method_missing(method, *args)
    method_name = method.to_s

    if method_name.start_with?('find_by_')
      options = []
      columns = method_name[8..-1].split("_and_")

      columns.each_with_index do |column, i|
          options << { :col => column, :val => args[i] }
      end

      where(options)
    else
      super
    end
  end

  def self.where(options)
    where = []
    values = []

    options.each do |option|
      values << option[:val]
      col = option[:col]

      comparator = option[:comparator]
      comparator ||= "="

      where << "#{col} #{comparator} ?"
    end

    sql = <<-SQL
      SELECT
        *
      FROM
        #{self::TABLE}
      WHERE
        #{where.join(' AND ')}
    SQL

    data = execute(sql, *values)
    data.map { |el| self.new(el) }
  end

  def self.all
    data = execute(<<-SQL)
    SELECT
      *
    FROM
      #{self::TABLE}

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
