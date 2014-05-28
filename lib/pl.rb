require 'active_model'
require 'active_record'
require 'active_record_tasks'
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
require_relative 'pl/entities/audio_block.rb'
require_relative 'pl/entities/commercial_block.rb'
require_relative 'pl/entities/song.rb'
require_relative 'pl/entities/spin.rb'
require_relative 'pl/entities/station.rb'
require_relative 'pl/entities/user.rb'
Dir[File.dirname(__FILE__) + '/pl/use-cases/*.rb'].each {|file| require_relative file }

Dotenv.load
