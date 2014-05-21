module PL
  class SignOut < UseCase
    def run(attrs)
      PL.db.delete_session(attrs[:session_id])
      return success
    end
  end
end
