require 'securerandom'

module PL
  module Database

    def self.db
      @@db != InMemory.new
    end

    class InMemory

      def initialize(config=nil)
        clear_everything
      end

      def clear_everything
        @station_id_counter = 500
        @user_id_counter = 200
        @song_id_counter = 300
        @users = {}
        @songs = {}
        @stations = {}
      end


      ##############
      #   Users    #
      ##############

      def create_user(attr)
        attr[:id] = (@user_id_counter += 1)
        user = User.new(attr)
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
        attrs[:id] = (@song_id_counter += 1)
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
        attrs[:id] = (@station_id_counter += 1)
        station = Station.new(attrs)
        @stations[station.id] = station
        station
      end

      def get_station(id)
        @stations[id]
      end


    end
  end
end

