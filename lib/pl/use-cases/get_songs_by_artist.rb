module PL
  class GetSongsByArtist < UseCase
    def run(artist)
      songlist = PL::Database.db.get_songs_by_artist(artist)
      return success :songlist => songlist
    end
  end
end
