require 'spec_helper'

describe "CreateRotationLevel" do

  it "creates a Rotation Level" do
      station = PL.db.create_station({ user_id: 999 })
      song = PL.db.create_song({ title: 'song' })
      result = PL::CreateRotationLevel.run({ station_id: station.id, song_id: song.id, level: "heavy" })
      expect(result.success?).to eq(true)
      expect(PL.db.get_station(station.id).heavy.map { |song| song.id }.include?(song.id)).to eq(true)
  end
end

