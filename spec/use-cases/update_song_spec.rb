require 'spec_helper'

describe "UpdateSong" do
  it "calls bullshit if song does not exist" do
    result = PL::UpdateSong.run({ song_id: 9999 })
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:song_not_found)
  end

  it "creates a song" do
    song = PL::Database.db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 100000 })
    result = PL::UpdateSong.run({ song_id: song.id, artist: "Josh Abbott Band" })
    expect(result.success?).to eq(true)
    expect(PL::Database.db.get_song(song.id).artist).to eq("Josh Abbott Band")
    expect(result.song.artist).to eq("Josh Abbott Band")
  end
end

