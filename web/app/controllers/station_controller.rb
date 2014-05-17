require 'pry-debugger'

class StationController < ApplicationController

  def dj_booth
    current_station.artificially_update_playlist
    @playlist = current_station.get_playlist_by_air_time(Time.now)
    result = PL::GetCurrentSpin.run(current_station.id)
    @current_spin = result.current_spin
  end

  def playlist_editor
  end

  def update_order
    PL::MoveSpin.run({ atation_id: current_station.id, old_position: params[:swap]["oldPosition"],
                    new_position: params[:swap]["newPosition"] })
  end
end
