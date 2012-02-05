#!/usr/bin/env ruby

require 'sqlite3'

# Constants
FILENAME = "wine.db"
SELECT_QUERY = "SELECT * FROM wine"
INSERT_QUERY = "INSERT INTO wine(name, price, purchase_date, drunk_date, rating, comment) VALUES( ?, ?, ?, ?, ?, ? )"

# Open DB
db = SQLite3::Database.new(FILENAME)

# Print DB contents
db.execute(SELECT_QUERY) do |row|
	puts row[1]
	puts "Price: #{row[2]}"
	puts "Purchased: #{row[3]}"
	puts "Drunk Date: #{row[4]}"
	puts "Rating: #{row[5]}"
	puts "Comment: #{row[6]}"
	puts
end

# Prompt user for new wine info
puts "Please expand our garden of wine knowledge by entering the attributes of a new wine."
puts "The Wine Hive Mind will kill...*brrrzzzt*...thanks you for your contribution."

# Collect new wine info
print "Name: "
name = gets.chomp
print "Price: "
price = gets.chomp
print "Purchase Date: "
purchase = gets.chomp
print "Drunk Date: "
drunk = gets.chomp
print "Rating: "
rating = gets.chomp
print "Comment: "
comment = gets.chomp
puts

# Insert wine info into the DB
db.execute(INSERT_QUERY, name, price, purchase, drunk, rating, comment)

# Confirm entry
puts "New wine entered."
puts "You may now return to your previous insignificant activities."

db.close()
