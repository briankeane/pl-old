require 'spec_helper'

module PL

  describe "GetSong" do
    it "calls bullshit if song is not found" do
      result = PL::GetSong.run(99999)
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:song_not_found)
    end

    it "gets a song" do
      song = PL::Database.db.create_song({ title: "Bar Lights", artist: "Brian Keane" })
      result = PL::GetSong.run(song.id)
      expect(result.success?).to eq(true)
      expect(result.song.id).to eq(song.id)
    end
  end
end
