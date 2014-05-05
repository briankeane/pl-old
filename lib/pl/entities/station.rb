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


      while sum < 500000   #604.8e+6 #milliseconds in a week
        song = db.get_song(sample_array.sample)
        playlist.push(song.id)
        sum += song.duration
      end

      # store playlist to scheduled_play table
      playlist.each do |play|
        PL::Database.db.add_to_playlist



    end
  end
end
