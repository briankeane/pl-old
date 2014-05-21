require 'active_record_tasks'


ActiveRecordTasks.configure do |config|
  # These are all the default values
  config.db_dir = 'db'
  config.db_config_path = 'db/config.yml'
  # In terminal, can set environment, for example, by doing DB_ENV=test
  config.env = ENV['DB_ENV'] || 'development'
end

# Run this AFTER you've configured
ActiveRecordTasks.load_tasks
