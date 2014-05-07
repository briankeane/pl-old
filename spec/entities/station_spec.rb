require 'spec_helper'

describe 'a station' do
  it "is created with an id, user_id " do
    station = PL::Station.new({ id: 12, user_id: 19 })
    expect(station.id).to eq(12)
    expect(station.user_id).to eq(19)
  end

end
