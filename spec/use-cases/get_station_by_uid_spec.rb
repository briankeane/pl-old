require 'spec_helper'

describe "GetStationByUID" do
  it "calls bullshit if the artist can't be found" do
    result = PL::GetStationByUID.run(999)
    expect(result.success?).to eq(false)
    expect(result.error).to eq(:station_not_found)
  end

  it "gets an array of tours by artist" do
    user = PL.db.create_user({ twitter: 'billy', password: 'password', email: 'bob@bob.com' })
    station = PL.db.create_station({ user_id: user.id })
    result = PL::GetStationByUID.run(user.id)
    expect(result.success?).to eq(true)
    expect(result[:station].id).to eq(station.id)
  end
end
