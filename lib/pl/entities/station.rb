require 'pry-debugger'
require 'chronic'

module PL
  class Station < Entity

    MS_IN_WEEK = 604.8e+6
    SECONDS_IN_WEEK = MS_IN_WEEK/1000

    attr_accessor :id, :user_id, :heavy, :medium, :light, :current_week, :station_start


    def initialize(attrs)
      attrs[:heavy] ||= []
      attrs[:medium] ||= []
      attrs[:light] ||= []
      super(attrs)
      @station_base_start = Chronic.parse('last thursday midnight')
      @station_start = Time.now
      @current_week = {}
    end

    def generate_playlist
      song_count = Hash.new(){0}
      playlist = []
      sum = 0
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


      # get the current playlist
      current_playlist = PL::Database.db.get_current_playlist(@id)

      # if it's the first week
      if current_playlist.size == 0


        # get the number of milliseconds left in week
        ms_in_current_week = MS_IN_WEEK - ((Time.now - last_thursday_midnight) * 1000)
        @current_week[:start_time] = Time.now
        start_time = @current_week[:start_time]

        # set the  start_midnight_time to midnight last thursday
        start_midnight_time = Chronic.parse('last thursday midnight')

      else
        # otherwise, use last week's midnight plus a week
        start_midnight_time = @current_week[:midnight_reference_time] + SECONDS_IN_WEEK

        # find the first_song_start_time (how many ms after midnight)
        # find the last song that's been played's played_at time and
        # keep adding until you reach the end of the week

      end




      # filter out for just this week
      current_playlist.select! { |spin| spin.id >= @current_week[:first_spin_id] }


      # sum = current_playlist.inject(0) { |sum, spin| sum + spin.song.duration }

      # if current_playlist.size == 0
      #   max_position = 0
      # else
      #   max_position = current_playlist.max_by { |spin| spin.current_position }
      # end

      # commercial_count = (sum/1620000).to_f

      # start_week_set? = false
      # while sum < 604.8e+6 #milliseconds in a week

      #   song = sample_array.sample
      #   spin = PL::Database.db.schedule_spin({ station_id: @id, audio_block: song, current_position: (max_position += 1) })

      #   # if it's the first song, set the week_start info
      #   if !start_week_set?
      #     @current_week[:first_spin_id] = spin.id
      #     start_week_set? = true
      #   end

      #   sum += song.duration

      #   # if it's time, add a commercial
      #   if (sum/1620000).to_f > commercial_count
      #     commercial_block = PL::Database.db.create_commercial_block
      #     PL::Database.db.schedule_spin({ station_id: @id, audio_block: commercial_block,
      #                                    current_position: (max_position += 1) })
      #     commercial_count += 1
      #     sum += commercial_block.duration
      #   end



      # store playlist to spin table
      playlist.each_with_index do |spin|
        song = PL::Database.db.get_song(spin)
        PL::Database.db.add_spin({ station_id: @id, song: song })
      end
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
