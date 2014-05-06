require 'spec_helper'
require 'pry-debugger'

describe 'station' do
  it "is created with id, user_id, heavy, medium, light" do
    station = PL::Station.new({ id: 1, user_id: 301, heavy: [12, 15, 17, 11, 93, 24, 13, 12], medium: [11, 24, 13, 19],
                                                  light: [11, 25, 27, 19] })
    expect(station.id).to eq(1)
    expect(station.user_id).to eq(301)
    expect(station.heavy[2]).to eq(17)
    expect(station.medium.size).to eq(4)
    expect(station.light[1]).to eq(25)
  end

  it "populates a week of programming" do
    PL::SeedDB.run
    station = PL::SeedDB.station1
    station.create_playlist
    expect(PL::Database.db.get_current_playlist(station.id).size > 2000).to eq(true)
  end

  it "provides the current playlist" do
    PL::SeedDB.run
    station = PL::SeedDB.station1
    station.create_playlist
    expect(PL::Database.db.get_current_playlist(station.id).size > 2000).to eq(true)
  end

end
