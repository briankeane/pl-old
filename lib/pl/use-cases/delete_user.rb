module PL
  class DeleteUser < UseCase
    def run(attrs)
      user = PL.db.get_user(attrs[:user_id])
      case
      when user == nil
        return failure(:user_not_found)
      else
        user = PL.db.delete_user(attrs[:user_id])
        return success
      end
    end
  end
end
