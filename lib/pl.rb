require 'active_model'
require 'active_record'
require 'active_record_tasks'
require 'pry-debugger'
require 'yaml'

module PL
  def self.db
    @db_class ||= Database::InMemory
    @__db_instance ||= @db_class.new(@env || 'test')
  end

  def self.db_class=(db_class)
    @db_class = db_class
  end

  def self.env=(env_name)
    @env = env_name
  end

end

require 'ostruct'
require_relative 'pl/entity.rb'
require_relative 'pl/use_case.rb'
require_relative 'pl/database/in_memory.rb'
require_relative 'pl/database/postgres_database.rb'
Dir[File.dirname(__FILE__) + '/pl/entities/*.rb'].each {|file| require_relative file }
Dir[File.dirname(__FILE__) + '/pl/use-cases/*.rb'].each {|file| require_relative file }
