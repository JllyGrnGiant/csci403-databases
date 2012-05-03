#!/usr/bin/env ruby

require 'mongo_mapper'

#
# Configuration
# 
MongoMapper.connection = Mongo::Connection.new('staff.mongohq.com', 10033) 
MongoMapper.database = "zoolicious" 
MongoMapper.database.authenticate('csci403', 'csci403')

#
# Class definitions
#
class Habitat
  include MongoMapper::Document

  key :name, String, :required => true
  key :location, String
  key :description, String

  def to_s
    "#{name}"
  end

end

#
# Core functions.
#
def main_menu
  puts "Main Menu."
  puts "A. List Zoos"
  puts "B. List Feeds"
  puts "C. List Habitats"
  puts "D. List Animals"
  puts "E. List Users"
  puts "F. Add a New Animal"
  puts "Q. Quit"
end

# Displays habitat ids, prompts the user to select one.
def capture_habitat
  habitats = Habitat.all
  command = -1
  while !((0..(habitats.size - 1)).include? command.to_i)
    habitats.each_with_index do |habitat, i|
      puts "#{i} #{habitat.name}"
    end
    puts "Habitat: "
    command = gets.chomp!
  end
  return habitats[command.to_i]
end

# Prompts the user for all animal attributes.
# Returns a name, description, cuteness score and a Habitat.
def capture_animal_attributes
  puts "Animal name: "
  name = gets.chomp!
  puts "Description: "
  description = gets.chomp!
  puts "Cuteness: "
  cuteness = gets.chomp!
  habitat = capture_habitat
  return name, description, cuteness.to_i, habitat
end

# Displays all the zoos.
def list_zoos
  # TODO
end

# Displays all the feeds.
def list_feeds
  # TODO
end

# Displays all the habitats, and any animal associated with that habitat.
def list_habitats
  # TODO
end

# Displays all the animals, and the habitat in which each lives.
def list_animals
  # TODO
end

# Displays all the users.
def list_users
  # TODO
end

# Captures attributes from the program user and saves a new
# animal in the database.
def create_animal
  name, description, cuteness, habitat = capture_animal_attributes
  # TODO
end

def execute_command(command)
  case command
  when "A"
    puts "Listing Zoos"
    list_zoos
  when "B"
    puts "Listing Feeds"
    list_feeds
  when "C"
    puts "Listing Habitats"
    list_habitats
  when "D"
    puts "Listing Animals"
    list_animals
  when "E"
    puts "Listing Users"
    list_users
  when "F"
    puts "Adding a new Animal"
    create_animal
  when "Q"
    puts "Quitting... buh-bye."
  else
    puts "Sorry, I don't know how to do that. Too bad so sad."
  end
end

command = nil
puts "Zoolicious application simulator. Whee!"
while (command != 'Q')
  main_menu
  execute_command(command = gets.chomp! )
end
