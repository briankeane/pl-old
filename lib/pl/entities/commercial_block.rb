module PL
  class CommercialBlock < AudioBlock

    attr_accessor :id, :duration

    def initialize(attrs)
      attrs[:duration] ||= 180000
      super(attrs)
    end


  end
end
