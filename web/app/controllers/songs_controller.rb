class SongsController < ApplicationController
  def new
  end

  def create
    file = params[:mp3file]

   AWS.config({
                  :access_key_id => ENV['S3_ACCESS_KEY_ID'],
                  :secret_access_key => ENV['S3_SECRET_KEY']
              })

    s3 = AWS::S3.new

    song_file = params[:song]
    song_name = song_file.original_filename

    sent_file = s3.buckets['playolaradio'].objects[song_name].write(:file => song_file)

    puts "#{sent_file.public_url}"

    respond_to do |format|
      format.js {render json: {data: sent_file.public_url}}
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
    result = PL.db.song_exists?(artist: params[:artist], title: params[:title], album: params[:album])
    render :json => { exists: result, parameters: params }
  end

end
