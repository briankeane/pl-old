module PL
  class CreateSong < UseCase
    def run(attrs)
      song = PL.db.create_song(attrs)
      return success :song => song
    end
  end
end
