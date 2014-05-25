require 'securerandom'
require 'pry-debugger'
require 'active_record'
require 'yaml'
require 'bcrypt'

module PL
  module Database

    # def self.db
    #   @__db_instance ||= PostgresDatabase.new(env)
    # end

    class PostgresDatabase
      def initialize(env)
          #TO DO: edit this to work
        # config_path = File.join(File.dirname(__FILE__), '../../../db/config.yml')
        # puts "USING: #{env} - #{YAML.load_file(config_path)[env]}"
        ActiveRecord::Base.establish_connection(YAML.load_file('db/config.yml')[env])
      end

      def clear_everything
        ActiveRecord::Base.subclasses.each(&:delete_all)
      end

      def add_stored_songs_to_db
        AWS.config ({
                        :access_key_id     => ENV['S3_ACCESS_KEY_ID'],
                        :secret_access_key =>  ENV['S3_SECRET_KEY']
                        })

        s3 = AWS::S3.new

        bucket = 'playolasongs'

        stored_songs = s3.buckets['playolasongs'].objects

        stored_songs.each do |s3_song_file|

          ar_song = Song.create({})

          temp_song_file = Tempfile.new("temp_song_file")

          temp_song_file.open()
          temp_song_file.write(s3_song_file.read)

          tag = ID3Tag.read(temp_song_file)

          ar_song.artist = tag.artist
          ar_song.title = tag.title
          ar_song.album = tag.album

          new_object = s3.buckets['playolasongs'].objects[(ar_song.id.to_s + '.' + s3_song_file_ext)]
          s3_song_file.copy_to(new_object)
          s3_song_file.delete
          @songs[song.id] = song
          ar_song.save
          Song.new(ar_song.attributes)
        end
      end





      #######################
      # ActiveRecord Models #
      #######################
      class AudioBlock < ActiveRecord::Base
        belongs_to :spin
      end

      class UserCommentary < AudioBlock
      end

      class Song < AudioBlock
        has_many :rotation_levels
      end

      class CommercialBlock < ActiveRecord::Base
        has_many :spins
      end

      class Spin < ActiveRecord::Base
        has_one :audio_block
        belongs_to :station
      end

      class Station < ActiveRecord::Base
        belongs_to :user
        has_many :rotation_levels
        has_many :spins
      end

      class User < ActiveRecord::Base
        has_one :station
      end

      class RotationLevel < ActiveRecord::Base
        belongs_to :station
        belongs_to :song
      end

      class Session < ActiveRecord::Base
        belongs_to :user
      end






      ##############
      #   Users    #
      ##############

      def create_user(attrs)
        password_digest = BCrypt::Password.create(attrs.delete(:password))
        attrs[:password_digest] = password_digest
        ar_user = User.create(attrs)
        PL::User.new(ar_user.attributes)
      end

      def get_user(id)
        if User.exists?(id)
          user = User.find(id)
          return PL::User.new(user.attributes)
        else
          return nil
        end
      end

      def delete_user(id)
        if User.exists?(id)
          User.find(id).destroy
          return true
        else
          return false
        end
      end

      def get_user_by_twitter(twitter)
        user = User.find_by twitter: twitter
        if user
          PL::User.new(user.attributes)
          return user
        else
          return nil
        end
      end

      def update_user(attrs)
        if User.exists?(attrs[:id])
          user = User.find(attrs.delete(:id))
          user.update_attributes(attrs)
          user.save
          return self.get_user(user.id)
        else
          return nil
        end
      end

      ##############
      #   Songs    #
      ##############

      def create_song(attrs)
        #remove the song_file from attrs and store it
        song_file = attrs.delete(:song_file)

        # create the object
        ar_song = Song.create(attrs)

        if song_file
          new_name = ar_song.id.to_str.join(song_file.original_filename.split('.').last)

          AWS.config({
                        :access_key_id => ENV['S3_ACCESS_KEY_ID'],
                        :secret_access_key => ENV['S3_SECRET_KEY']
                    })

          s3 = AWS::S3.new

          #rename the song_file with the id
          song_file.original_filename = song_id.to_s + '.' + song_file.original_filename.split('.').last
          song_name = song_file.original_filename

          sent_file = s3.buckets['playolaradio'].objects[song_file.original_filename].write(:file => song_file)
        end

        PL::Song.new(ar_song.attributes)
      end

      def song_exists?(attrs)  #title, artist, album
        if Song.where(["title = ? and artist = ? and album = ?", attrs[:title], attrs[:artist], attrs[:album]]).size > 0
          return true
        else
          return false
        end
      end


      def get_song(id)
        song = Song.find(id)
        PL::Song.new(song.attributes)
      end

############################################################### COME BACK TO THIS
      def get_songs_by_title(title)
        ar_songs = Song.find_by title: title
        ar_songs = Song.where('title LIKE ?', title + "%").order('title ASC')

        songs = []
        ar_songs.each do |song|
          song = PL::Song.new(song.attributes)
          songs << song
        end
        songs
      end

      def get_songs_by_artist(artist)
        ar_songs = Song.where('artist LIKE ?', artist + "%").order('title ASC')
        songs = []
        ar_songs.each do |song|
          song = PL::Song.new(song.attributes)
          songs << song
        end
        songs
      end

      def update_song(attrs)
        song = Song.find(attrs.delete(:id))
        if song
          song.update_attributes(attrs)
          song.save
        end
        Song.new(song.attributes)
      end

      def get_all_songs
        ar_songs = Song.all

        songs = []
        ar_songs.each do |song|
          song = PL::Song.new(song.attributes)
          songs << song
        end
        songs = songs.sort_by { |a| [a.artist, a.title] }

        songs
      end

      ##############
      #   Station  #
      ##############

      def create_station(attrs)    # (id), user_id, heavy, medium, light, seconds_of_commercial_per_hour
        heavy = attrs.delete(:heavy)
        medium = attrs.delete(:medium)
        light = attrs.delete(:light)

        if heavy
          heavy.each do |song|
            RotationLevel.new({ song_id: song.id, station_id: attrs[:station_id], level:
              'heavy' })
          end
        end

        if medium
          medium.each do |song|
            RotationLevel.new({ song_id: song.id, station_id: attrs[:station_id], level:
              'medium' })
          end
        end

        if light
          light.each do |song|
            RotationLevel.new({ song_id: song.id, station_id: attrs[:station_id], level:
              'light' })
          end
        end

        ar_station = Station.create(attrs)
        # add the heavy medium and light back in to attr for the Entity
        attrs[:heavy] = heavy
        attrs[:medium] = medium
        attrs[:light] = light

        station = PL::Station.new(attrs)
        station.id = ar_station.id
        return station
      end

      def get_station(id)
        ar_station = Station.find(id)
        station = PL::Station.new({ id: ar_station.id,
                      user_id: ar_station.user_id,
                      seconds_of_commercial_per_hour: ar_station.seconds_of_commercial_per_hour })
        station_rotation_levels = RotationLevel.where(station_id: id)

        heavy = []
        medium = []
        light = []

        station_rotation_levels.each do |rl|
          case rl.level
          when "heavy"
            heavy << self.get_song(rl.song_id)
          when "medium"
            medium << self.get_song(rl.song_id)
          when "light"
            light << self.get_song(rl.song_id)
          end
        end

        station.heavy = heavy
        station.medium = medium
        station.light = light
        station
      end

      def get_station_by_uid(user_id)
        station = Station.find_by user_id: user_id
        self.get_station(station.id)
      end

      def update_station(attrs)
        station = Station.find(attrs[:id].delete)
        station.update_attributes(attrs)
        station.save
        get_station(attrs[:id])
      end


      ####################
      # Commercial Block #
      ####################

      def create_commercial_block(attrs = {})
        ar_commercial_block = CommercialBlock.create(attrs)
        CommercialBlock.new(ar_commercial_block.attributes)
      end

      def get_commercial_block(id)
        ar_commercial_block = CommercialBlock.find(id)
        CommercialBlock.new(ar_commercial_block.attributes)
      end

      ####################
      #     Spin         #
      ####################

      def get_current_playlist(station_id)

        ar_spins = Spin.where(station_id: station_id).order('current_position ASC')

        ar_spins = ar_spins.select {|x| x.played_at == nil }

        spins = ar_spins.map { |spin| self.get_spin(spin.id) }
        spins
      end

      def get_full_playlist(station_id)
        ar_spins = Spin.where(station_id: station_id).order('current_position ASC')
        spins = []
        ar_spins.each do |spin|
          spins.push(self.get_spin(spin.id))
        end
        spins
      end

      def get_past_spins(station_id)
        # ar_spins = Spin.where(station_id: station_id).where('played_at != NULL').order('played_at ASC')
        ar_spins = Spin.where(station_id: station_id).order('played_at ASC')
        ar_spins = ar_spins.select { |spin| spin.played_at != nil }

        spins = ar_spins.map { |spin| self.get_spin(spin.id) }

        spins
      end

      def schedule_spin(attrs) # :id, :audio_block, :station_id, :current_position, :played_at
        audio_block = attrs.delete(:audio_block)
        case
        when audio_block.is_a?(PL::Song)
          attrs[:audio_block_type] = "Song"
        when audio_block.is_a?(PL::CommercialBlock)
          attrs[:audio_block_type] = "CommercialBlock"
        end

        attrs[:audio_block_id] = audio_block.id
        ar_spin = Spin.create(attrs)

        spin = PL::Spin.new(ar_spin.attributes)
        spin.audio_block = audio_block
        spin
      end

      def get_spin(id)
        ar_spin = Spin.find(id)

        if !ar_spin
          return nil
        end

        spin = PL::Spin.new({ station_id: ar_spin.station_id,
                              current_position: ar_spin.current_position,
                              id: ar_spin.id,
                              played_at: ar_spin.played_at })

        case ar_spin.audio_block_type
        when 'Song'
          spin.audio_block = Song.find(ar_spin.audio_block_id)
        when 'CommercialBlock'
          spin.audio_block = CommercialBlock.find(ar_spin.audio_block_id)
        when 'Commentary'
        end
        spin
      end

      def get_spin_by_station_id_and_current_position(attrs)  # current_position, station_id
        ar_spin = Spin.find_by(station_id: attrs[:station_id], current_position: attrs[:current_position])

        if !ar_spin
          return nil
        end

        self.get_spin(ar_spin.id)
      end

      def record_spin_time(attrs)
        ar_spin = Spin.find(attrs[:spin_id])
        ar_spin.played_at = attrs[:played_at]
        ar_spin.save
        return get_spin(ar_spin.id)
      end

      def get_next_spin(station_id)
        self.get_current_playlist(station_id).first
      end

      def get_current_spin(station_id)
        self.get_past_spins(station_id).last
      end

      def move_spin(attrs)   #old_position, new_position, station_id
        #if moving backwards
        if attrs[:old_position] > attrs[:new_position]
          playlist_slice = self.get_current_playlist(attrs[:station_id]).select { |spin| (spin.current_position >= attrs[:new_position]) && (spin.current_position <= attrs[:old_position]) }

          playlist_slice.each do |spin|
            ar_spin = Spin.find(spin.id)
            ar_spin.current_position += 1
            ar_spin.save
            spin.current_position += 1
          end

          ar_spin = Spin.find(playlist_slice.last.id)
          ar_spin.current_position = attrs[:new_position]
          ar_spin.save
          playlist_slice.last.current_position = attrs[:new_position]

          # return true for successful move
          return true
        elsif attrs[:old_position] < attrs[:new_position]
          playlist_slice = self.get_current_playlist(attrs[:station_id]).select { |spin| (spin.current_position >= attrs[:old_position]) && (spin.current_position <= attrs[:new_position]) }

          playlist_slice.each do |spin|
            ar_spin = Spin.find(spin.id)
            ar_spin.current_position -= 1
            ar_spin.save
            spin.current_position -= 1
          end

          ar_spin = Spin.find(playlist_slice.first.id)
          ar_spin.current_position = attrs[:new_position]
          ar_spin.save
          playlist_slice.first.current_position = attrs[:new_position]

          # return true for successful move
          return true
        end

        # return false if nothing was moved
        return false

      end

      ##################################################################
      #     insert_spin                                                #
      ##################################################################
      #  This method inserts a spin into the playlist.  In order to    #
      #  avoid rearranging the entire playlist, it deletes a song at   #
      #  3am the next morning to even things out for the day.          #
      ##################################################################
      def insert_spin (attrs)   # takes :station_id, :insert_position
      end

      ##############
      #  Sessions  #
      ##############

      def create_session(user_id)
        session_id = SecureRandom.uuid
        Session.create({ user_id: user_id, session_id: session_id })
        return session_id
      end

      def get_uid_from_sid(session_id)
        if Session.exists?(session_id: session_id)
          session = Session.find_by(session_id: session_id)
          return session.user_id
        else
          return nil
        end
      end

      def delete_session(session_id)
        if Session.exists?(session_id: session_id)
          session = Session.find_by session_id: session_id
          session.delete
          return true
        else
          return nil
        end
      end


      ####################
      #   RotationLevel  #
      ####################
      def create_rotation_level(attrs)    # station_id, song_id, level
        rotationlevel = RotationLevel.create(attrs)
        station = get_station(attrs[:station_id])
      end

      def delete_rotation_level(attrs) # station_id, song_id, level
        rotationlevel = RotationLevel.find_by(station_id: attrs[:station_id],
                                              song_id: attrs[:song_id],
                                              level: attrs[:level])
        if rotationlevel
          rotationlevel.delete
        else
          return false
        end
      end


    end
  end
end

