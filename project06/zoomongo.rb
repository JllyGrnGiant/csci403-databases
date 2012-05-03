#! /usr/bin/env ruby
require 'mongo_mapper'

MongoMapper.connection = Mongo::Connection.new('staff.mongohq.com', 10033) 
MongoMapper.database = "zoolicious" 
MongoMapper.database.authenticate('csci403', 'csci403')

class Animal
	include MongoMapper::Document
	key :name, String, :required => true
	key :description, String
	key :cuteness, Integer
end

puts "Aaaalmost there... Aaaaaalmost there..."
puts "Displaying all the Animals in the database..."
puts

Animal.all(:order => :name.asc).each do |animal|
	print animal.name, ", ", animal.description, ", ", animal.cuteness, "\n"
end
