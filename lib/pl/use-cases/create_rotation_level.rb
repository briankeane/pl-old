module PL
  class CreateRotationLevel < UseCase
    def run(attrs)  #level, station_id, song_id
      new_rotation_level = PL.db.create_rotation_level(attrs)
      return success
    end
  end
end
