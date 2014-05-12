module PL
  class GetSongsByTitle < UseCase
    def run(title)
      songlist = PL::Database.db.get_songs_by_title(title)
      return success :songlist => songlist
    end
  end
end
