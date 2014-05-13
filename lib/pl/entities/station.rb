require 'pry-debugger'
require 'chronic'

module PL
  class Station < Entity

    MS_IN_WEEK = 604.8e+6
    SECONDS_IN_WEEK = MS_IN_WEEK/1000
    SECONDS_IN_DAY = 86400

    attr_accessor :id, :user_id, :heavy, :medium, :light
    attr_accessor :seconds_of_commercial_per_hour

    def initialize(attrs)
      attrs[:heavy] ||= []
      attrs[:medium] ||= []
      attrs[:light] ||= []
      attrs[:seconds_of_commercial_per_hour] ||= 360
      super(attrs)
      @station_start = Time.now
    end


    ##################################################################
    #     create_sample_array                                        #
    ##################################################################
    #  This method creates an array of samples for the playlist      #
    #  generator to randomly select from.  It populates each song    #
    #  in the correct ratio.                                         #
    ##################################################################

    def create_sample_array
      sample_array = []

      # add songs to sample-array in correct ratios
      27.times do                           # for heavy rotation population
        @heavy.each do |song|
          sample_array.push(song)
        end
      end

      17.times do                        # for medium rotation population
        @medium.each do |song|
          sample_array.push(song)
        end
      end

      2.times do                         # for light rotation population
        @light.each do |song|
          sample_array.push(song)
        end
      end
      sample_array
    end



    ##################################################################
    #     generate_playlist                                          #
    ##################################################################
    #  This method generates or extends the current playlist         #
    #  through the following thursday at midnight.  It takes         #
    #  commercial time into account but does not insert commercial   #
    #  blocks or placeholders.  Currently it gets the ratios correct #
    #  but later it should be ammended to account for:               #
    #                                                                #
    #     1) no repeats (spacing between same artist/song)           #
    #     2) station ids                                             #
    ##################################################################

    def generate_playlist
      # set up beginning and ending dates for comparison
      this_thursday_midnight = Chronic.parse('this thursday midnight')
      next_thursday_midnight = this_thursday_midnight + SECONDS_IN_WEEK
      current_playlist = PL::Database.db.get_current_playlist(@id)

      # set max_position and time_tracker initial values
      if current_playlist.size == 0
        max_position = 0
        time_tracker = Time.now
      else
        max_position = current_playlist.last.current_position
        current_spin = PL::Database.db.get_current_spin(@id)
        time_tracker = self.playlist_estimated_end_time
      end

      # calibrate commercial_block_counter for start-time
      commercial_block_counter = (time_tracker.to_f/1800.0).floor

      sample_array = self.create_sample_array

      while time_tracker < next_thursday_midnight
        song = sample_array.sample
        spin = PL::Database.db.schedule_spin({ station_id: @id,
                                              audio_block: song,
                                         current_position: (max_position += 1) })

        time_tracker += (song.duration/1000)

        #if it's time for a commercial, move time-tracker over it's block
        if (time_tracker.to_f/1800.0).floor > commercial_block_counter
          commercial_block_counter += 1
          time_tracker += (@seconds_of_commercial_per_hour/2)
        end
      end  # endwhile

      #if it's the first playlist, start the station
      if PL::Database.db.get_current_playlist(@id).size == PL::Database.db.get_full_playlist(@id).size
        first_spin = PL::Database.db.get_current_playlist(@id).first
        PL::Database.db.record_spin_time({ spin_id: first_spin.id,
                                         played_at: Time.now })
      end
    end


    ##################################################################
    #     station.get_playlist_by_air_time                           #
    ##################################################################
    #  This method returns 125 min of estimated_playlist for a given #
    #  time.  It stores the 'estimated air_time' in the actual       #
    #  Spin object, and returns an array of those objects.           #
    ##################################################################

    def get_playlist_by_air_time(air_time)

      air_time = air_time - 600    #subtract 5 minutes so the playlist starts a little early
      playlist = PL::Database.db.get_current_playlist(@id)

      playlist_counter = -1  # so 1st iteration will be 0
      commercial_block_counter = (air_time.to_f/1800.0).floor     # determines which 30 min block we're starting in
      current_spin = PL::Database.db.get_current_spin(@id)

      # if there is no current spin (station not running), return false
      if current_spin == nil
        return false
      end


      time_tracker = current_spin.played_at + (current_spin.audio_block.duration/1000)
      formatted_playlist = []


      while time_tracker < (air_time + 7500)    # 2 hrs 5 min past start_time (2 hrs past requested time)
        spin = playlist[(playlist_counter += 1)]
        spin.estimated_air_time = time_tracker

        time_tracker += (spin.audio_block.duration/1000)

        # if it's past the air_time we're looking for, add it to the array
        if spin.estimated_air_time > air_time
          formatted_playlist << spin
        end

        # if it's time for a commercial
        if (time_tracker.to_f/1800.0).floor > commercial_block_counter
          commercial_block = PL::CommercialBlock.new({ estimated_air_time: time_tracker,
                                                                 duration: ((@seconds_of_commercial_per_hour/2) * 1000) })
          formatted_playlist << commercial_block
          commercial_block_counter += 1
          time_tracker += (commercial_block.duration/1000)
        end
      end

      formatted_playlist
    end


    #################################################################
    #     playlist_estimated_end_time                               #
    #################################################################
    # This method finds the estimated end time for the current      #
    # playlist by placing a time-tracker at the last known definite #
    # airtime and counting through the playlist, accounting for     #
    # commercials at the top and bottom of the hour                 #
    #################################################################

    def playlist_estimated_end_time
      current_playlist = PL::Database.db.get_current_playlist(@id)
      current_spin = PL::Database.db.get_current_spin(@id)
      # set time_tracker to the end of the current_spin
      time_tracker = current_spin.played_at + (current_spin.audio_block.duration/1000)

      # calibrate the commercial block counter
      commercial_block_counter = (time_tracker.to_i/1800).floor

      # iterate through the rest of the playlist, adding time as needed
      current_playlist.each_with_index do |spin|
        time_tracker = time_tracker + (spin.audio_block.duration/1000)

        # check if commercial is needed and add it if so
        if (time_tracker.to_f/1800.0).floor > commercial_block_counter
          time_tracker += (@seconds_of_commercial_per_hour/2)
          commercial_block_counter += 1
        end
      end

      return time_tracker
    end

    def next_song_start_time
      current_spin = PL::Database.db.get_current_spin(@id)
      current_spin.played_at + (current_spin.audio_block.duration/1000)
    end

    #################################################################
    #     artificially_update_playlist                              #
    #################################################################
    # This method simulates the streaming server having been run    #
    # by updating all records before the current time as having     #
    # been played.                                                  #
    #################################################################

    def artificially_update_playlist
      air_time = Time.now
      playlist = PL::Database.db.get_current_playlist(@id)

      playlist_counter = -1  # so 1st iteration will be 0
      commercial_block_counter = (air_time.to_f/1800.0).floor     # determines which 30 min block we're starting in
      current_spin = PL::Database.db.get_current_spin(@id)

      # if there is no current spin (station not running), return false
      if current_spin == nil
        return false
      end


      time_tracker = current_spin.played_at + (current_spin.audio_block.duration/1000)
      formatted_playlist = []


      while time_tracker < air_time    # seek the current time
        spin = playlist[(playlist_counter += 1)]
        spin.played_at = time_tracker

        time_tracker += (spin.audio_block.duration/1000)

        # if it's time for a commercial
        if (time_tracker.to_f/1800.0).floor > commercial_block_counter
          commercial_block = PL::CommercialBlock.new({ estimated_air_time: time_tracker,
                                                                 duration: ((@seconds_of_commercial_per_hour/2) * 1000) })
          formatted_playlist << commercial_block
          commercial_block_counter += 1
          time_tracker += (@seconds_of_commercial_per_hour/2)
        end
      end
    end

    def playlist
      PL::Database.db.get_current_playlist(@id)
    end
  end
end
