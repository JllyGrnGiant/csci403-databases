#!/usr/bin/env ruby

require 'sqlite3'

# constants
# database filename
FILENAME = 'wine_test.db'
# sqlite create table statements
CLEAR_TABLE_STMTS = ['DELETE FROM countries;',
	'DELETE FROM grapes;',
	'DELETE FROM grapes_vineyards;',
	'DELETE FROM grapes_wines;',
	'DELETE FROM regions;',
	'DELETE FROM vineyards;',
	'DELETE FROM wineries;',
	'DELETE FROM wines;']

# open database
db = SQLite3::Database.new(FILENAME)

# create tables
CLEAR_TABLE_STMTS.each do |stmt|
	db.execute(stmt);
end

#close database
db.close()
