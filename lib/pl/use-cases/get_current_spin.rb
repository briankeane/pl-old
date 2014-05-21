module PL
  class GetCurrentSpin < UseCase
    def run(station_id)
      current_spin = PL.db.get_current_spin(station_id)
      case current_spin
      when nil
        return failure(:spin_not_found)
      else
        return success :current_spin => current_spin
      end
    end
  end
end
