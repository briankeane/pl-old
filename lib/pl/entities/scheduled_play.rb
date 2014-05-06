module PL
  class ScheduledPlay < Entity

    attr_accessor :id, :song, :station_id, :current_position, :played_at

    def initialize(attrs)
      super(attrs)
    end

  end
end
