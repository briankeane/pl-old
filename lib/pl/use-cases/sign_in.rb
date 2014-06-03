require 'pry-debugger'

module PL
  class SignIn < UseCase
    def run(attrs)
      user = PL.db.get_user_by_twitter(attrs[:twitter])
      case
      when user == nil
        return failure(:twitter_not_found)
      when user.password_correct?(attrs[:password]) == false
        return failure(:incorrect_password)
      else
        session_id = PL.db.create_session(user.id)
        return success :session_id => session_id, :user => user
      end
    end
  end
end
