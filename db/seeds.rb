# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the bin/rails db:seed command (or created alongside the database with db:setup).
#
# Examples:
#
#   movies = Movie.create([{ name: "Star Wars" }, { name: "Lord of the Rings" }])
#   Character.create(name: "Luke", movie: movies.first)

def find_or_create_leader(name)
  Leader.find_by(name: name) || Leader.create(name: name)
end

def find_or_create_user(name, email)
  User.find_by(name: name) || User.create(name: name, email: email)
end

def vacation_status(status_xlsx)
  case status_xlsx
  when 'Pendiente'
    0
  when 'Aprobado'
    1
  when 'Rechazado'
    2
  end
end

# Create a user and assinged a vacation
xlsx = Roo::Spreadsheet.open('./tmp/vacations.xlsx')
xlsx.sheet(0).each_with_index do |row, index|
  next if index.zero?
  
  # create user
  user = find_or_create_user(row[1], row[2])

  # create leader if not exists
  leader = find_or_create_leader(row[3])

  # assign leader to user
  user.leader_id = leader.id if leader.present? && user.leader_id.blank?

  # assign user to leader
  leader.users << user if leader.present? && !leader.users.include?(user)
  
  # skip row if it is an incapacity
  next if row[6] == 'Incapacidad'
  
  # assign vacation to user
  user.vacations << Vacation.create(start_date: row[4], end_date: row[5], status: vacation_status(row[8]) )
end