require 'pry-debugger'

module PL
  class Station < Entity
    attr_accessor :id, :user_id, :heavy, :medium, :light

    def initialize(attrs)
      attrs[:heavy] ||= []
      attrs[:medium] ||= []
      attrs[:light] ||= []
      super(attrs)
    end

    def create_playlist
      song_count = Hash.new(){0}
      playlist = []
      sum = 0
      sample_array = []

      # add to sample at correct population
      27.times do
        @heavy.each do |song|
          sample_array.push(song)
        end
      end

      17.times do
        @medium.each do |song|
          sample_array.push(song)
        end
      end

      2.times do
        @light.each do |song|
          sample_array.push(song)
        end
      end

      current_playlist = PL::Database.db.get_current_playlist(@id)
      sum = current_playlist.inject(0) { |sum, play| sum + play.song.duration }
      if current_playlist.size == 0
        max_position = 0
      else
        max_position = current_playlist.max_by { |play| play.current_position }
      end
      while sum < 604.8e+6 #milliseconds in a week
        song = sample_array.sample
        PL::Database.db.schedule_play({ station_id: @id, song: song, current_position: (max_position += 1) })
        sum += song.duration
      end

      # store playlist to scheduled_play table
      playlist.each_with_index do |play|
        song = PL::Database.db.get_song(play)
        PL::Database.db.add_play({ station_id: @id, song: song })
      end
    end

    def playlist
      PL::Database.db.get_current_playlist(@id)
    end


  end
end
