module PL
  class CreateStation < UseCase
    def run(attrs)
      user = PL.db.get_user(attrs[:user_id])
      case
      when user == nil
        return failure(:user_not_found)
      else
        station = PL.db.create_station(attrs)
        return success :station => station
      end
    end
  end
end
