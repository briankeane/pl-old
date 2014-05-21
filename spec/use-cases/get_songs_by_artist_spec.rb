require 'spec_helper'

describe 'GetSongsByTitle' do
  before do
    PL.db.clear_everything
    @song1 = PL.db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                 audio_id: 2 })
    @song2 = PL.db.create_song({ title: "Bar Nights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                 audio_id: 2 })
    @song3 = PL.db.create_song({ title: "Bar Brights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                 audio_id: 2 })
    @song4 = PL.db.create_song({ title: "Bar First", artist: "Bob Dylan", duration: 226000, sing_start: 5000, sing_end: 208000,
                                 audio_id: 2 })
    @song5 = PL.db.create_song({ title: "Hell", artist: "Bob Dylan", duration: 226000, sing_start: 5000, sing_end: 208000,
                                 audio_id: 2 })
  end

  it "gets a list of songs by artist" do
    result = PL::GetSongsByArtist.run("Brian Keane")
    expect(result.success?).to eq(true)
    expect(result.songlist.size).to eq(3)
    expect(result.songlist[0].title).to eq("Bar Brights")
    expect(result.songlist[2].title).to eq("Bar Nights")
  end
end
