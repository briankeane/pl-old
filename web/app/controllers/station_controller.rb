require 'pry-debugger'

class StationController < ApplicationController

  def dj_booth
    @playlist = current_station.get_playlist_by_air_time(Time.now)
  end

  def playlist_editor
  end

  def update_order
    PL::MoveSpin({ old_position: params[:swap]["oldPosition"],
                    new_position: params[:swap]["newPosition"] })
  end
end
