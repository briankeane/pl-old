class StationController < ApplicationController

  def dj_booth
    if !PL.db.get_station_by_uid(current_user.id)
      redirect_to new_station_path
    end

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
    if !PL.db.get_station_by_uid(current_user.id)
      redirect_to new_station_path
    end
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
    binding.pry
    render :json => {request: params, usecaseResponse: result }
  end

  def new
    @songs = PL.db.get_all_songs
    @heavy = []
    @medium = []
    @light = []
  end

  def create
    # grab the songs from the ids
    heavy = params[:heavy].map { |id| PL::db.get_song(id.to_i) }
    medium = params[:medium].map { |id| PL::db.get_song(id.to_i) }
    light = params[:light].map { |id| PL::db.get_song(id.to_i) }

    result = PL::CreateStation.run({ user_id: current_user.id, heavy: heavy, medium: medium, light: light })
    render :json => { result: result }
  end

end

