module PL
  class Station < Entity
    attr_accessor :id, :user_id

    def initialize(attrs)
      super(attrs)
    end

  end
end
