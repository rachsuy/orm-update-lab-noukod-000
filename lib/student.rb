require_relative "../config/environment.rb"

class Student

  # Remember, you can access your database connection anywhere in this class
  #  with DB[:conn] 
    attr_accessor :name, :grade
    attr_reader :id 
    
    def initialize(id="",name,grade)
      @id = id
      self.name = name
     self.grade = grade
end
    def self.create_table
      sql = <<-SQL
      CREATE TABLE IF NOT EXISTS students(
        id Integer PRIMARY KEY,
        name TEXT,
        grade TEXT);
      
     SQL
    DB[:conn].execute(sql)
  end


  def self.drop_table
    sql =  <<-SQL
      DROP TABLE students
        SQL
    DB[:conn].execute(sql)
  end

  def update
    sql = <<-SQL
      update students
        set name = ?,
           grade = ?
      where id = ?
    SQL

    DB[:conn].execute(sql, self.name, self.grade, self.id)
  end

  def save
      if self.id
          self.update
      else
        sql = <<-SQL
          Insert into students (name, grade) values (?, ?)
        SQL

        DB[:conn].execute(sql, self.name, self.grade)
        @id = DB[:conn].execute("Select last_insert_rowid() from students").flatten.first
      end
    end


end
