require 'spec_helper'

describe "CreateSong" do

  it "creates a song" do
    result = PL::CreateSong.run({ title: "Bar Lights", artist: "Brian Keane", duration: 100000 })
    expect(result.success?).to eq(true)
    expect(PL::Database.db.get_song(result.song.id).artist).to eq("Brian Keane")
    expect(result.song.artist).to eq("Brian Keane")
  end
end

