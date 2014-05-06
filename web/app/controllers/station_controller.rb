class StationController < ApplicationController
  def dj_booth
    if !signed_in?
      flash[:notice] = "Please sign in"
      redirect_to root_path
    else
      result = PL::GetStationByUID.run(current_user)
      @station = result.station
    end
  end

  def playlist_editor
  end
end
