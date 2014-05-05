module PL
  class ScheduledPlay < Entity

    attr_accessor :id, :song_id, :station_id, :current_position, :played_at

    def initialize(attrs)
      attrs[:played_at] ||= nil
      super(attrs)
    end

  end
end
