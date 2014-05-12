module PL
  class UpdateUser < UseCase
    def run(attrs)
      user = PL::Database.db.get_user(attrs[:user_id])

      if user == nil
        return failure(:user_not_found)
      else
        user = PL::Database.db.update_user(attrs)
        return success :user => user
      end
    end
  end
end
