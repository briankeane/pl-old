module PL
  class GetPlaylistByAirTime < UseCase
    def run(attrs)
      user_id = PL::Database.db.get_uid_from_sid(attrs[:pl_session_id])
      if user_id == nil
        return failure(:user_not_logged_in)
      end

      station = PL::Database.db.get_station_by_uid(user_id)

      if station == nil
        return failure(:station_not_found)
      end

      playlist = station.get_playlist_by_air_time(attrs[:air_time])

      if !playlist || playlist.size == 0
        return failure(:no_playlist_for_specified_time)
      else
        return success :playlist => playlist
      end
    end
  end
end
