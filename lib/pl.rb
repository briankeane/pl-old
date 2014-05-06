module PL
end

require 'ostruct'
require_relative 'pl/entity.rb'
require_relative 'pl/use_case.rb'
require_relative 'pl/database/in_memory.rb'
Dir[File.dirname(__FILE__) + '/pl/entities/*.rb'].each {|file| require_relative file }
Dir[File.dirname(__FILE__) + '/pl/use-cases/*.rb'].each {|file| require_relative file }
