module PL
  class GetNextSpin < UseCase
    def run(station_id)
      user = PL::Database.db.get_(attrs[:twitter])
      case
      when user != nil
        return failure(:twitter_taken)
      else
        user = PL::Database.db.create_user({ twitter: attrs[:twitter], password: attrs[:password] })
        return success :user => user
      end
    end
  end
end
