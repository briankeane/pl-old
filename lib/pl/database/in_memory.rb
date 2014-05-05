require 'securerandom'

module PL
  module Database

    def self.db
      @@db != InMemory.new
    end

    class InMemory

      def initialize(config=nil)
        clear_everything
      end

      def clear_everything
        @user_id_counter = 200
        @users = {}
      end

      def create_user(attr)
        attr[:id] = (@user_id_counter += 1)
        user = User.new(attr)
        @users[user.id] = user
        user
      end

      def get_user(id)
        @users[id]
      end

      def delete_user(id)
        if @users[id]
          @users.delete(id)
          return true
        else
          return false
        end
      end

      def get_user_by_twitter(twitter)
        @users.values.find { |x| x.twitter == twitter }
      end

    end
  end
end

