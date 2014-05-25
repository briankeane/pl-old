require 'spec_helper'

describe "DeleteRotationLevel" do

  it "deletes a Rotation Level" do
      station = PL.db.create_station({ user_id: 999 })
      song = PL.db.create_song({ title: 'song' })
      PL.db.create_rotation_level({ station_id: station.id, song_id: song.id, level: "heavy" })
      expect(PL.db.get_station(station.id).heavy.map { |song| song.id }.include?(song.id)).to eq(true)
      result = PL::DeleteRotationLevel.run({ station_id: station.id, song_id: song.id, level: "heavy" })
      expect(result.success?).to eq(true)
      expect(PL.db.get_station(station.id).heavy.map { |song| song.id }.include?(song.id)).to eq(false)

  end
end

