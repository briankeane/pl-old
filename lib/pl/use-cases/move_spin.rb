module PL
  class MoveSpin < UseCase   # takes new_position, old_position, pl_session_id
    def run(attrs)
      user_id = PL.db.get_uid_from_sid(attrs[:pl_session_id])

      if user_id == nil
        return failure(:user_not_logged_in)
      end

      station = PL.db.get_station_by_uid(user_id)

      if station == nil
        return failure(:station_not_found)
      end

      spin1 = PL.db.get_spin_by_station_id_and_current_position({ current_position: attrs[:old_position],
                                            station_id: station.id })

      if spin1 == nil
        return failure(:invalid_old_position)
      end

      new_position = PL.db.get_spin_by_station_id_and_current_position({ current_position: attrs[:new_position],
                                                  station_id: station.id })

      if new_position == nil
        return failure(:invalid_new_position)
      end

      PL.db.move_spin({ station_id: station.id,
                                old_position: attrs[:old_position],
                                new_position: attrs[:new_position] })
      return success
    end
  end
end
