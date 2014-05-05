require 'spec_helper'

describe 'Song' do
  it "is created with title, duration, sing_start, sing_end, artist, id" do
    song = PL::Song.new({title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000, id: 1 })
    expect(song.title).to eq("Bar Lights")
    expect(song.artist).to eq("Brian Keane")
    expect(song.duration).to eq(226000)
    expect(song.sing_start).to eq(5000)
    expect(song.sing_end).to eq(208000)
    expect(song.id).to eq(1)
  end
end
