require "taglib"

class SongsController < ApplicationController
  def new
  end

  def create
    file = params[:mp3file]
    TagLib::FileRef.open(file.path) do |fileref|
      tag = fileref.tag
      @title = fileref
      # @artist = tag.artist
    end
  end

  def update
  end

  def edit
  end

  def destroy
  end

  def index
  end

  def show
  end

  def check_for_song
    render :json => { exists: false, parameters: params }
  end

end
