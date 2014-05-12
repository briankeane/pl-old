require 'securerandom'
require 'pry-debugger'

module PL
  module Database

    def self.db
      @@db ||= InMemory.new
    end

    class InMemory

      def initialize(config=nil)
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

      def update_station_a(station)
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

      def get_spin(attrs)  # current_position, station_id
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
        elsif attrs[:old_position] < attrs[:new_position]
          playlist_slice = self.get_current_playlist(attrs[:station_id]).select { |spin| (spin.current_position >= attrs[:old_position]) && (spin.current_position <= attrs[:new_position]) }

          playlist_slice.each { |spin| spin.current_position -= 1 }

          playlist_slice.first.current_position = attrs[:new_position]
        end
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
    end
  end
end

