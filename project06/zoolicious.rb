#!/usr/bin/env ruby

require 'rubygems'
require 'active_record'
require 'logger'

#
# Configuration
# 
#ActiveRecord::Base.logger = Logger.new(STDOUT)
ActiveRecord::Base.establish_connection(
  :host => 'localhost',
  :username => 'joshua',
  :password => '47Imean2',
  :adapter => 'mysql2',
  :database => 'zoolicious'
)

#
# Class definitions
#
class Habitat < ActiveRecord::Base

  has_many :animals
  belongs_to :zoo

  def to_s
    name
  end

end

class Animal < ActiveRecord::Base
  belongs_to :habitat
  has_and_belongs_to_many :users
  has_and_belongs_to_many :feeds

  validates :cuteness, :inclusion => {:in => 1..100}

  def to_s
	name
  end
end

class Zoo < ActiveRecord::Base
  has_many :habitats

  def to_s
    name
  end
end

class User < ActiveRecord::Base
  has_and_belongs_to_many :animals

  def to_s
    "#{first_name} #{last_name}"
  end
end

class Feed < ActiveRecord::Base
  has_and_belongs_to_many :animals

  def to_s
    name
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
  command = nil
  while (!(habitats.collect { |h| h.id }.include? command.to_i))
    habitats.each do |habitat|
      puts "#{habitat.id} #{habitat.name}"
    end
    puts "Habitat: "
    command = gets.chomp!
  end
  return habitats.select { |h| h.id == command.to_i}.first
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

# Displays all the zoos and their habitats.
def list_zoos
  zoos = Zoo.all
  zoos.each do |zoo|
    habitats = zoo.habitats
    puts "#{zoo.id} #{zoo.name}"
	habitats.each do |habitat|
	  puts "\t#{habitat}"
	end
	puts
  end
end

# Displays all the feeds and the animals that eat each feed.
def list_feeds
  feeds = Feed.all
  feeds.each do |feed|
	puts feed
	animals = feed.animals
	animals.each do |animal|
	  puts "\t#{animal}"
	end
  end
end

# Displays all the habitats, the zoo that owns each habitat,
# and the animals that occupy each habitat.
def list_habitats
  habitats = Habitat.all
  habitats.each do |habitat|
	animals = habitat.animals
    puts "#{habitat.id} #{habitat.name} - #{habitat.zoo}"
	animals.each do |animal|
	  puts "\t#{animal}"
	end
  end
end

# Displays all the animals, the people that favor each animal,
# and the habitat in which each lives.
def list_animals
  animals = Animal.all
  animals.each do |animal|
	users = animal.users
    puts "#{animal.id} #{animal.name} - #{animal.habitat}"
	users.each do |user|
	  puts "\t#{user}"
	end
  end
end

# Displays all the users and their favorite animals.
def list_users
  users = User.all
  users.each do |user|
    animals = user.animals
    puts "#{user.id} #{user} - #{user.username}"
	animals.each do |animal|
	  puts "\t#{animal}"
	end
  end
end

# Captures attributes from the program user and saves a new
# animal in the database.
def create_animal
  name, description, cuteness, habitat = capture_animal_attributes
  puts habitat
  Animal.create!(:name => name, :description => description, :cuteness => cuteness, :habitat_id => habitat.id)
rescue
  puts $!
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
