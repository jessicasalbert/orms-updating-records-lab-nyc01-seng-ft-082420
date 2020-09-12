require_relative "../config/environment.rb"

class Student

  attr_accessor :id, :name, :grade

  def initialize(id=nil, name, grade)
    @id = id
    @name = name
    @grade=grade
  end

  def self.new_from_db(row)
    # create a new Student object given a row from the database
    student = Student.new(row[0], row[1], row[2])
    # student.id = row[0]
    # student.name = row[1]
    # student.grade = row[2]
    student
  end

  def update
    # create a new Student object given a row from the database
    sql = <<-SQL
    UPDATE students SET name = ?, grade = ? 
    SQL
    rows = DB[:conn].execute(sql, self.name, self.grade )
    # student.id = row[0]
    # student.name = row[1]
    # student.grade = row[2]
    #student
  end

  def self.all
    # retrieve all the rows from the "Students" database
    # remember each row should be a new instance of the Student class
    sql = <<-SQL
    SELECT * FROM students
    SQL
    rows = DB[:conn].execute(sql)
    rows.map { |row| Student.new_from_db(row) }
  end

  def self.find_by_name(name)
    # find the student in the database given a name
    # return a new instance of the Student class
    sql = <<-SQL
    SELECT * FROM students WHERE name = ? LIMIT 1
    SQL
    stud = DB[:conn].execute(sql, name)[0]
    student = Student.new_from_db(stud)
  end

  def self.create(name, grade)
    Student.new(name, grade).save
  end
  
  def save
    if !self.id
      sql = <<-SQL
        INSERT INTO students (name, grade) 
        VALUES (?, ?)
      SQL

      student = DB[:conn].execute(sql, self.name, self.grade)
      self.id = DB[:conn].execute("SELECT last_insert_rowid() FROM students")[0][0]
    else
      self.update
    end
  end
  
  def self.create_table
    sql = <<-SQL
    CREATE TABLE IF NOT EXISTS students (
      id INTEGER PRIMARY KEY,
      name TEXT,
      grade TEXT
    )
    SQL

    DB[:conn].execute(sql)
  end

  def self.drop_table
    sql = "DROP TABLE IF EXISTS students"
    DB[:conn].execute(sql)
  end




end
