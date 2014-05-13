require 'pry-debugger'

module PL
  class GeneratePlaylist < UseCase
    def run(station_id)
      station = PL::Database.db.get_station(station_id)


      if station == nil
        return failure(:station_not_found)
      end

      station.generate_playlist
      return success
    end
  end
end
