module PL
  class UpdateSong < UseCase
    def run(attrs)
      song = PL::Database.db.get_song(attrs[:song_id])

      if song == nil
        return failure(:song_not_found)
      else
        song = PL::Database.db.update_song(attrs)
        return success :song => song
      end
    end
  end
end
