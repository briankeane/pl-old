module PL
  class Spin < Entity

    attr_accessor :id, :audio_block, :station_id, :current_position, :played_at, :estimated_air_time

    def initialize(attrs)
      super(attrs)
    end

  end
end
