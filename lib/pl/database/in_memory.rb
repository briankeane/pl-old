require 'securerandom'
require 'tempfile'
require 'aws-sdk'
require 'mp3info'

module PL
  module Database

    # def self.db
    #   @__db_instance ||= InMemory.new
    # end

    class InMemory

      def initialize(env=nil)
        clear_everything
      end

      def clear_everything
        @station_id_counter = 500
        @user_id_counter = 200
        @song_id_counter = 300
        @spin_counter = 700
        @commercial_block_counter = 800
        @users = {}
        @songs = {}
        @stations = {}
        @spins = {}
        @sessions = {}
        @commercial_blocks = {}
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
          id = (@song_id_counter += 1)

          s3_song_file_ext = s3_song_file.key.split('.').last

          song = Song.new({ id: id })

          # If metadata has not yet been stored, download the entire file and store it
          if !s3_song_file.metadata[:pl_duration]
            temp_song_file = Tempfile.new("temp_song_file")

            temp_song_file.open()
            temp_song_file.write(s3_song_file.read)

            #tag = ID3Tag.read(temp_song)

            mp3 = ''
            Mp3Info.open(temp_song_file) do |song_tags|
              mp3 = song_tags
            end

            s3_song_file.metadata[:pl_artist] =  mp3.tag.artist
            s3_song_file.metadata[:pl_title] = mp3.tag.title
            s3_song_file.metadata[:pl_album] = mp3.tag.album
            s3_song_file.metadata[:pl_duration] = (mp3.length * 1000).to_i
          end

          song.artist = s3_song_file.metadata[:pl_artist]
          song.title = s3_song_file.metadata[:pl_title]
          song.album = s3_song_file.metadata[:pl_album]
          song.duration = s3_song_file.metadata[:pl_duration]

          new_key = (song.id.to_s + '_' + song.artist + '_' + song.title + '.' + s3_song_file_ext)

          # change the name to the new key if necessary
          if !stored_songs[new_key].exists?
            new_object = s3.buckets['playolasongs'].objects[new_key]
            s3_song_file.copy_to(new_object)
            s3_song_file.delete
          end

          @songs[song.id] = song
        end

      end

      ##############
      #   Users    #
      ##############

      def create_user(attrs)
        id = (@user_id_counter += 1)
        attrs[:id] = id
        user = User.new(attrs)
        @users[user.id] = user
        user
      end

      def get_user(id)
        @users[id]
      end

      def delete_user(id)
        if @users[id]
          @users.delete(id)
          return true
        else
          return false
        end
      end

      def get_user_by_twitter(twitter)
        @users.values.find { |x| x.twitter == twitter }
      end

      def update_user(attrs)
        user = @users[attrs[:id]]
        attrs.delete(:id)

        # insert updated attributes
        attrs.each do |attr_name, value|
          setter = "#{attr_name}="
          user.send(setter, value) if user.class.method_defined?(setter)
        end

        user
      end

      ##############
      #   Songs    #
      ##############

      def create_song(attrs)
        id = (@song_id_counter += 1)
        attrs[:id] = id
        song = Song.new(attrs)
        @songs[song.id] = song
        song
      end

      def get_song(id)
        @songs[id]
      end

      def get_songs_by_title(title)
        @songs.values.select { |song| song.title.match(/^#{title}/) }.sort_by { |x| x.title }
      end

      def get_songs_by_artist(artist)
        @songs.values.select { |song| song.artist.match(/^#{artist}/) }.sort_by { |x| x.title }
      end

      def update_song(attrs)
        song = @songs[attrs[:id]]
        attrs.delete(:id)

        # insert updated attributes
        attrs.each do |attr_name, value|
          setter = "#{attr_name}="
          song.send(setter, value) if song.class.method_defined?(setter)
        end

        song
      end

      def song_exists?(attrs)  #title, artist, album
        songs = @songs.values.select { |song| song.title == attrs[:title] &&
                                              song.album == attrs[:album] &&
                                              song.artist == attrs[:artist] }

        if songs.size > 0
          return true
        else
          return false
        end
      end

      def get_all_songs
        all_songs = @songs.values.sort_by { |a| [a.artist, a.title] }
        all_songs
      end



      ##############
      #   Station  #
      ##############

      def create_station(attrs)    # (id), user_id, heavy, medium, light, seconds_of_commercial_per_hour
        id = (@station_id_counter += 1)
        attrs[:id] = id
        station = Station.new(attrs)
        @stations[station.id] = station
        station
      end

      def get_station(id)
        @stations[id]
      end

      def get_station_by_uid(user_id)
        @stations.values.find { |station| station.user_id == user_id }
      end

      def update_station(station)
        # Grab the data by station.id
        attrs = @stations[station.id]
        attrs[:user_id] = station.user_id

        # Merge in the changes (station.whatever)
      end


      ####################
      # Commercial Block #
      ####################

      def create_commercial_block(attrs = {})
        id = (@commercial_block_counter += 1)
        attrs[:id] = id
        commercial_block = PL::CommercialBlock.new(attrs)
        @commercial_blocks[id] = commercial_block
        commercial_block
      end

      def get_commercial_block(id)
        @commercial_blocks[id]
      end

      ####################
      #     Spin         #
      ####################

      def get_current_playlist(station_id)
        spins = @spins.values.select { |spin| spin.station_id == station_id }
        spins.select { |spin| spin.played_at == nil }.sort_by { |x| x.current_position }
      end

      def get_full_playlist(station_id)
        @spins.values.select { |spin| spin.station_id == station_id }
      end

      def get_past_spins(station_id)
        spins = @spins.values.select { |spin| spin.station_id == station_id }
        spins.select! { |spin| spin.played_at != nil }
        spins.sort_by! { |spin| spin.played_at }
        spins
      end

      def schedule_spin(attrs) # :id, :audio_block, :station_id, :current_position, :played_at
        id = (@spin_counter += 1)
        attrs[:id] = id
        spin = Spin.new(attrs)
        @spins[spin.id] = spin
        spin
      end

      def get_spin_by_station_id_and_current_position(attrs)  # current_position, station_id
        spins = @spins.values.select { |spin| spin.station_id == attrs[:station_id] }
        spins.find { |spin| spin.current_position == attrs[:current_position] }
      end

      def record_spin_time(attrs)
        @spins[attrs[:spin_id]].played_at = attrs[:played_at]
        @spins[attrs[:spin_id]]
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

          playlist_slice.each { |spin| spin.current_position += 1 }

          playlist_slice.last.current_position = attrs[:new_position]

          # return true for successful move
          return true
        elsif attrs[:old_position] < attrs[:new_position]
          playlist_slice = self.get_current_playlist(attrs[:station_id]).select { |spin| (spin.current_position >= attrs[:old_position]) && (spin.current_position <= attrs[:new_position]) }

          playlist_slice.each { |spin| spin.current_position -= 1 }

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
        station = self.get_station(attrs[:station_id])
        playlist = get_current_playlist(station.id)
        time_tracker = station.next_song_start_time
        position_tracker = playlist.first.current_position

        # seek to proper position, updating playlist time along the way
        while position_tracker < attrs[:insert_position]
          playlist[position_tracker].estimated_air_time = time_tracker
          time_tracker += (playlist[position_tracker].duration/1000)
        end



        # Make a new space by adding 1 to all current_positions until the next day
        # if it's in the 3am hour, set marker to the following 2am
        if time_tracker.hour == 3
          change_hour = 2
        else
          change_hour = 3
        end

        # adjust current_position until 3am (or 2am tomorrow if it's past 3am today)
        while time_tracker.hour != change_hour
          @songs[playlist[position_tracker].id].current_position += 1
          position_tracker += 1
        end

        # delete a late-night spin to preserve rest of the week order
        @songs.delete([playlist[position_tracker].id])

        # insert the new spin
        self.schedule_spin({ station_id: attrs[:station_id],
                       current_position: attrs[:insert_position],
                       audio_block: attrs[:audio_block] })

      end

      ##############
      #  Sessions  #
      ##############

      def create_session(user_id)
        session_id = SecureRandom.uuid
        @sessions[session_id] = user_id
        return session_id
      end

      def get_uid_from_sid(session_id)
        @sessions[session_id]
      end

      def delete_session(session_id)
        if @sessions[session_id]
          @sessions.delete(session_id)
          return true
        else
          return false
        end
      end

      ###################
      #  RotationLeveL  #
      ###################
      def create_rotation_level(attrs)   #station_id, song_id, level
        case attrs[:level]
        when "heavy"
          if !@stations[attrs[:station_id]].heavy.map { |song| song.id }.include?(self.get_song(attrs[:song_id]).id)
            @stations[attrs[:station_id]].heavy.push(get_song(attrs[:song_id]))
            return true
          end
        when "medium"
          if !@stations[attrs[:station_id]].medium.map { |song| song.id }.include?(self.get_song(attrs[:song_id]).id)
            @stations[attrs[:station_id]].medium.push(get_song(attrs[:song_id]))
            return true
          end
        when "light"
          if !@stations[attrs[:station_id]].light.map { |song| song.id }.include?(self.get_song(attrs[:song_id]).id)
            @stations[attrs[:station_id]].light.push(get_song(attrs[:song_id]))
            return true
          end
        end
      end

      def delete_rotation_level(attrs)  #station_id, song_id, level
        case attrs[:level]
        when "heavy"
          # get a list of the ids in rotation
          ids = @stations[attrs[:station_id]].heavy.map { |song| song.id }

          # delete them
          did_it_delete = @stations[attrs[:station_id]].heavy.reject! { |song| song.id == attrs[:song_id] }
          return did_it_delete
        when "medium"
          # get a list of the ids in rotation
          ids = @stations[attrs[:station_id]].medium.map { |song| song.id }

          # delete them
          did_it_delete = @stations[attrs[:station_id]].medium.reject! { |song| song.id == attrs[:song_id] }
          return did_it_delete
        when "light"
          # get a list of the ids in rotation
          ids = @stations[attrs[:station_id]].light.map { |song| song.id }

          # delete them
          did_it_delete = @stations[attrs[:station_id]].light.reject! { |song| song.id == attrs[:song_id] }
          return did_it_delete
        end
      end
    end
  end
end

