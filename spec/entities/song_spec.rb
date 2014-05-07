require 'spec_helper'

describe 'a song' do
  it "is created with an id, title, artist, sing_start, sing_end, audio_id" do
    song = PL::Song.new({ id: 12, title: "I'll Sing About Mine", artist: "Brian Keane", duration: 60000,
                                  sing_start: 6000, sing_end: 8000, audio_id: 19 })
    expect(song.id).to eq(12)
    expect(song.title).to eq("I'll Sing About Mine")
    expect(song.duration).to eq(60000)
    expect(song.sing_start).to eq(6000)
    expect(song.sing_end).to eq(8000)
    expect(song.audio_id).to eq(19)
  end

end
