
module PL
  class GetStationByUID < UseCase
    def run(user_id)
      case
      when PL::Database.db.get_station_by_uid(user_id) == nil
        return failure :station_not_found
      else
        return success :station => (PL::Database.db.get_station_by_uid(user_id))
      end
    end
  end
end
