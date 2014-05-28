require 'active_record_tasks'
require 'dotenv/tasks'


ActiveRecordTasks.configure do |config|
  # These are all the default values
  config.db_dir = 'db'
  config.db_config_path = 'db/config.yml'
  # In terminal, can set environment, for example, by doing DB_ENV=test
  config.env = ENV['DB_ENV'] || 'development'
end

# Run this AFTER you've configured
ActiveRecordTasks.load_tasks



task :load_app do
  puts "Loading application"
  # [code to require and set up your application would go here]
  require_relative './lib/pl.rb'
  require 'securerandom'
  require 'active_record'
  require 'mp3info'
  require 'aws-sdk'
end

namespace :db do
  task :migrate do
    puts "Migrating database"
    # [code to migrate database would go here]
  end

  task :load_songs => [:migrate, :load_app] do
    puts "Seeding database"
    # configure s3
    AWS.config ({
                    :access_key_id     => ENV['S3_ACCESS_KEY_ID'],
                    :secret_access_key =>  ENV['S3_SECRET_KEY']
                    })

    s3 = AWS::S3.new

    bucket = 'playolasongs'
    stored_songs = s3.buckets['playolasongs'].objects

    stored_songs.each do |s3_song_file|

      #create a song object
      ar_song = PL::Database::PostgresDatabase::Song.create({})

      # IF the file has no proprietary metadata
      if !s3_song_file.metadata[:pl_duration]
        temp_song_file = Tempfile.new("temp_song_file")

        temp_song_file.open()
        temp_song_file.write(s3_song_file.read)

        # get the id3 tags
        mp3 = ''
        Mp3Info.open(temp_song_file) do |song_tags|
          mp3 = song_tags
        end

        # store the metadata on amazon s3
        s3_song_file.metadata[:pl_artist] = mp3.tag.artist
        s3_song_file.metadata[:pl_title] = mp3.tag.title
        s3_song_file.metadata[:pl_album] = mp3.tag.album
        s3_song_file.metadata[:pl_duration] = (mp3.length * 1000).to_i
      end

      # finish creating the song object
      ar_song.artist = s3_song_file.metadata[:pl_artist]
      ar_song.title = s3_song_file.metadata[:pl_title]
      ar_song.album = s3_song_file.metadata[:pl_album]
      ar_song.duration = s3_song_file.metadata[:pl_duration]

      #rename the s3 file if necessary, and store the key in the database
      s3_song_file_ext = s3_song_file.key.split('.').last
      new_key = (('0' * (5 - ar_song.id.to_s.size)) +  ar_song.id.to_s + '_' + ar_song.artist + '_' + ar_song.title + '.' + s3_song_file_ext)
      ar_song.key = s3_song_file.key

      if !stored_songs[new_key].exists?
        new_object = s3.buckets['playolasongs'].objects[new_key]
        s3_song_file.copy_to(new_object)
        s3_song_file.delete
      end

      ar_song.save
    end
  end
end
