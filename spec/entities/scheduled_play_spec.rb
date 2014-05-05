require 'spec_helper'

describe 'ScheduledPlay' do
  it "is created with a song_id, station_id, date, time" do
    song = db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                                          audio_id: 2 })


  end

end
