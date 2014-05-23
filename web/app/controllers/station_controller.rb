require 'pry-debugger'

class StationController < ApplicationController

  def dj_booth
    current_station.artificially_update_playlist
    @playlist = current_station.get_playlist_by_air_time(Time.now)
    result = PL::GetCurrentSpin.run(current_station.id)
    @current_spin = result.current_spin
  end

  def playlist_editor
    @songs = [ { artist: "1", id: 1, title: "I'll Sing About Mine"},
              { artist: "2", id: 2, title: "Today"},
              { artist: "3", id: 3, title: "I"},
              { artist: "4", id: 4, title: "Will" },
              { artist: "5", id: 5, title: "Fucking" },
              { artist: "6", id: 6, title: "Figure" },
              { artist: "7", id: 7, title: "This"},
              { artist: "8", id: 8, title: "Out"},
              { artist: "9", id: 9, title: "I'll Sing About Mine"},
              { artist: "10", id: 10, title: "I'll Sing About Mine"},
              { artist: "11", id: 11, title: "I'll Sing About Mine"},
              { artist: "12", id: 12, title: "I'll Sing About Mine"}
              ]
    end



  def update_order
    result = PL::MoveSpin.run({ pl_session_id: session[:pl_session_id],
                        old_position: params[:oldPosition],
                        new_position: params[:newPosition] })
    render :json => {request: params, usecaseResponse: result }
  end
end

