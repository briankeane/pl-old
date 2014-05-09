require 'pry-debugger'
require 'chronic'

module PL
  class Station < Entity

    MS_IN_WEEK = 604.8e+6
    SECONDS_IN_WEEK = MS_IN_WEEK/1000
    SECONDS_IN_DAY = 86400

    attr_accessor :id, :user_id, :heavy, :medium, :light, :current_week, :station_start
    attr_accessor :last_playlist_start_date

    def initialize(attrs)
      attrs[:heavy] ||= []
      attrs[:medium] ||= []
      attrs[:light] ||= []
      super(attrs)
      @station_start = Time.now
    end

    def create_sample_array
      sample_array = []

      # add songs to sample-array in correct population
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
      sample_array
    end


    def generate_first_playlist

      # if there's already a playlist, exit
      if PL::Database.db.get_full_playlist(@id).size != 0
        return false
      end


      playlist = []
      sum = 0
      sample_array = self.create_sample_array
      last_thursday_midnight = Chronic.parse('last thursday midnight')

      # get the number of milliseconds left in week
      @last_playlist_start_date = last_thursday_midnight
      ms_in_current_week = MS_IN_WEEK - ((Time.now - last_thursday_midnight) * 1000)
      max_position = 0
      commercial_count = 0

      while sum < ms_in_current_week
        song = sample_array.sample
        spin = PL::Database.db.schedule_spin({ station_id: @id, audio_block: song, current_position: (max_position += 1) })

        sum += song.duration

        # if it's time, add a commercial
        if (sum/1620000).to_f > commercial_count
          commercial_block = PL::Database.db.create_commercial_block
          PL::Database.db.schedule_spin({ station_id: @id, audio_block: commercial_block,
                                         current_position: (max_position += 1) })
          commercial_count += 1
          sum += commercial_block.duration
        end
      end  # endwhile
    end  # end generate_first_playlist


    def generate_playlist

      # set up beginning and ending dates for comparison
      last_thursday_midnight = Chronic.parse('last thursday midnight')
      this_thursday_midnight = Chronic.parse('this thursday midnight')
      next_thursday_midnight = this_thursday_midnight + SECONDS_IN_WEEK
      max_position = PL::Database.db.get_current_playlist(@id).last.current_position

      # FIND the currently playing spin and use it to calculate estimated_start_time for next week
      current_spin = PL::Database.db.get_current_spin(@id)
      estimated_time_start = current_spin.played_at + (current_spin.audio_block.duration/1000)

      next_playlist_estimated_start_time = PL::Database.db.get_current_playlist(@id).inject(estimated_time_start) { |time, spin| time + (spin.audio_block.duration/1000) }

      time_counter = next_playlist_estimated_start_time

      sample_array = self.create_sample_array
      sum = 0
      commercial_count = 0

      while time_counter < next_thursday_midnight
        song = sample_array.sample
        spin = PL::Database.db.schedule_spin({ station_id: @id, audio_block: song, current_position: (max_position += 1) })

        time_counter += (song.duration/1000)
        sum += song.duration

        # if it's time, add a commercial
        if (sum/1620000).to_f > commercial_count
          commercial_block = PL::Database.db.create_commercial_block
          PL::Database.db.schedule_spin({ station_id: @id, audio_block: commercial_block,
                                         current_position: (max_position += 1) })
          commercial_count += 1
          time_counter += (commercial_block.duration/1000)
        end
      end  # endwhile
    end


    def now_playing
      playlist = PL::Database.db.get_current_playlist(@id).max_by { |spin| spin.played_at }
      PL::Database.db.get_
    end


    def playlist
      PL::Database.db.get_current_playlist(@id)
    end
  end
end
