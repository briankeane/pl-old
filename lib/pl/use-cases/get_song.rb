module PL
  class GetSong < UseCase
    def run(song_id)
      song = PL::Database.db.get_song(song_id)
      case song
      when nil
        return failure(:song_not_found)
      else
        return success :song => song
      end
    end
  end
end
