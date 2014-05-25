require 'pry-debugger'

class StationController < ApplicationController

  def dj_booth
    current_station.artificially_update_playlist
    @playlist = current_station.get_playlist_by_air_time(Time.now)
    result = PL::GetCurrentSpin.run(current_station.id)
    @current_spin = result.current_spin
  end

  def add_to_rotation
    result = PL::CreateRotationLevel.run({ station_id: current_station.id,
                                            song_id: params[:song_id],
                                            level: params[:level] })

    render :json => { success: true }
  end

  def delete_from_rotation
    result = PL::DeleteRotationLevel.run({ station_id: current_station.id,
                                            song_id: params[:song_id],
                                            level: params[:level] })

    render :json => { success: true }
  end


  def playlist_editor
    @songs = PL.db.get_all_songs
    @heavy = current_station.heavy
    @medium = current_station.medium
    @light = current_station.light
    (@heavy + @medium + @light).each do |song_a|
      @songs.delete_if { |song_b| song_a.id == song_b.id }
    end

  end


  def update_order
    result = PL::MoveSpin.run({ pl_session_id: session[:pl_session_id],
                        old_position: params[:oldPosition],
                        new_position: params[:newPosition] })
    render :json => {request: params, usecaseResponse: result }
  end
end

