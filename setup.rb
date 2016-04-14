require 'sqlite3'

$db = SQLite3::Database.new "address_book.db"

module AddressBookDB
  def self.setup
    $db.execute(
      <<-SQL
        CREATE TABLE contacts(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          first_name VARCHAR(64) NOT NULL,
          last_name VARCHAR(64) NOT NULL,
          company VARCHAR(64) NOT NULL,
          phone_num INTEGER NOT NULL,
          email_add VARCHAR(64) NOT NULL,
          created_at DATETIME NOT NULL,
          updated_at DATETIME NOT NULL
        );
      SQL
    )

    $db.execute(
      <<-SQL
      CREATE TABLE group_contact(
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        contact_id INTEGER,
        group_id INTEGER,
        FOREIGN KEY(contact_id) REFERENCES contacts(id),
        FOREIGN KEY(group_id) REFERENCES group_1(id)
      );
      SQL
    )

    $db.execute(
      <<-SQL
        CREATE TABLE group_1(
          id INTEGER PRIMARY KEY AUTOINCREMENT,
          name VARCHAR(64) NOT NULL
        );
    SQL
    )

  end

  def self.seed

    $db.execute(
      <<-SQL
      INSERT INTO contacts 
       (first_name, last_name, company, phone_num, email_add, created_at, updated_at)
       VALUES
       ('Brandon', 'Pong', 'Ah Long Sdn Bhd', '1993123123', 'orangutan@gmail.com', DATETIME('now'), DATETIME('now'));         
       SQL
       )
  end
  
  

end

class Contact
attr_accessor :first_name, :last_name, :company, :phone_num, :email_add
  def initialize(data = {})
    @first_name = data[:first_name]
    @last_name = data[:last_name]
    @company = data[:company]
    @phone_num = data[:phone_num]
    @email_add = data[:email_add]
  end

  def self.add(first_name, last_name, company, phone_num, email_add)
     $db.execute(
      "INSERT INTO contacts (first_name, last_name, company, phone_num, email_add, created_at, updated_at)
        VALUES (?, ?, ?, ?, ?, DATETIME('now'), DATETIME('now'))",
         first_name, last_name, company, phone_num, email_add)  
  end

  def self.delete(input)
    $db.execute( "DELETE FROM contacts WHERE id = ?", input)
  end


  def self.change(id, input)
    $db.execute("
        UPDATE contacts 
        SET email_add = ?
        WHERE contacts.id = ?; ",
        input, id
    )
  end

end

class Group_contact
  attr_accessor :contact_id, :group_id
  def initialize(data = {})
    @contact_id = data[:contact_id]
    @group_id = data[:group_id]
  end
end

class Group_1
  attr_accessor :name
  def initialize(data = {})
    @name = data[:name]
  end

  def self.add(name)
     $db.execute(
      "INSERT INTO group_1 (name)
        VALUES (?)", name)  
  end

  def self.delete(input)
    $db.execute( "DELETE FROM group_1 WHERE id = ?", input)
    $db.execute( "DELETE FROM group_contact WHERE group_id = ?", input)

  end

end


#Contact.add('Leslie','Ang', 'Holland Sdn Bhd', '12312312', 'leslie88@gmail.com')
Group_1.delete("2")
Group_1.delete("3")
#Contact.all
# Group_1.add('KNNBCCB')
#--------------------------------------------------------------------------------



#   def self.where(input)
#     $db.execute( "SELECT * FROM students where first_name = ?", input)
#   end

#   def self.add(first_name, last_name, gender, birthday, email, phone)
#    $db.execute(
#     "INSERT INTO students (first_name, last_name, created_at, updated_at)
#         VALUES (?, ?, DATETIME('now'), DATETIME('now'))",
#         first_name, last_name)  
#   end

#   def self.delete(input)
#     $db.execute( "DELETE FROM students WHERE id = ?", input )
      
#   end

#   def self.all
#     $db.execute(
#       <<-SQL
#         SELECT * FROM students;
#       SQL
#       ) do |row|
#       p row
#     end
#   end

#   def self.show_first_name(input)
#      $db.execute( "SELECT * FROM students WHERE id = ?", input )
#   end
  
#   def self.show_attr(input)
#     $db.execute(
#   <<-SQL
#   SELECT "#{input}" FROM students;
#   SQL
#   )
#   end

# end



# ### DRIVER CODE ###
# # student = Student.new()
# # Student.seed
# # puts Student.add('Kan', 'Lan')
# # puts Student.add('Nina',"Kan")
# Student.add('Kiam', 'Siap', 'Shemale', '1880-23-01', 'okohhh@hotmail.com', '999')
# Student.all
