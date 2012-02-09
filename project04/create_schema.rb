#!/usr/bin/env ruby

require 'sqlite3'

# constants
# database filename
FILENAME = 'wine_test.db'
# sqlite create table statements
CREATE_TABLE_STMTS = ['CREATE TABLE countries(id integer not null primary key autoincrement, name text);',
	'CREATE TABLE grapes(id integer not null primary key autoincrement, name text);',
	'CREATE TABLE grapes_vineyards(grape_id integer, vineyard_id integer);',
	'CREATE TABLE grapes_wines(grape_id integer, wine_id integer);',
	'CREATE TABLE regions(id integer not null primary key autoincrement, name text, country_id integer);',
	'CREATE TABLE vineyards(id integer not null primary key autoincrement, parcel_id text, name text, region_id integer, winery_id integer);',
	'CREATE TABLE wineries(id integer not null primary key autoincrement, tax_id text, name text);',
	'CREATE TABLE wines(id integer not null primary key autoincrement, sku text, name text, vintage integer, price real, purchase_date text, drunk_date text, rating integer, comment text, winery_id integer);']

# open database
db = SQLite3::Database.new(FILENAME)

# create tables
CREATE_TABLE_STMTS.each do |stmt|
	db.execute(stmt);
end

#close database
db.close()
