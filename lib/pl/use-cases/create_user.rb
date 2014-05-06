module PL
  class CreateUser < UseCase
    def run(attrs)
      user = PL::Database.db.get_user_by_twitter(attrs[:twitter])
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
