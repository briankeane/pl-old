module PL
  class Spin < Entity

    attr_accessor :id, :audio_block, :station_id, :current_position, :played_at

    def initialize(attrs)
      super(attrs)
    end

  end
end
