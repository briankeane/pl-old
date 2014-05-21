module PL
  class GetNextSpin < UseCase
    def run(station_id)
      next_spin = PL.db.get_next_spin(station_id)
      case next_spin
      when nil
        return failure(:spin_not_found)
      else
        return success :next_spin => next_spin
      end
    end
  end
end
