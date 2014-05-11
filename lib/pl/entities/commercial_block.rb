module PL
  class CommercialBlock < AudioBlock

    attr_accessor :id, :duration, :played_at, :estimated_air_time

    def initialize(attrs)
      attrs[:duration] ||= 180000
      super(attrs)
    end


  end
end
