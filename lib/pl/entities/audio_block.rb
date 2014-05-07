module PL
  class AudioBlock < Entity
    attr_accessor :id, :duration, :audio_id, :title

    def initialize(attrs)  #title, artist, id, duration, sing_start, sing_end
      super(attrs)
    end
  end
end
