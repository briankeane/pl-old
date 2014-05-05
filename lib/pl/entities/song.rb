module PL
  class Song < Entity

    attr_accessor :title, :artist, :id, :duration, :sing_start, :sing_end, :audio_id

    def initialize(attrs)  #title, artist, id, duration, sing_start, sing_end
      super(attrs)
    end

  end
end
