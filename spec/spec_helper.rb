require './lib/pl.rb'
require './lib/seed_db.rb'


RSpec.configure do |config|
  # Configure each test to always use a new singleton instance
  config.before(:each) do
    PL::Database.instance_variable_set(:@__db_instance, nil)
  end
end
