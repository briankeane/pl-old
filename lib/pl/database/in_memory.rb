require 'securerandom'

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
        @scheduled_play_counter = 700
        @users = {}
        @songs = {}
        @stations = {}
        @scheduled_plays = []
        @sessions = {}

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

      def create_station(attrs)
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



      ####################
      #  Scheduled Play  #
      ####################

      def get_current_playlist(station_id)
        station_plays = @scheduled_plays.select { |play| play.station_id == station_id }
        station_plays.select { |play| play.current_position != nil }.sort_by { |x| x.current_position }
      end

      def schedule_play(attrs)
        attrs[:id] = (@scheduled_play_counter += 1)
        play = ScheduledPlay.new(attrs)
        @scheduled_plays << play
        play
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

