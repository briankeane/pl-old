require 'spec_helper'

describe 'a station' do
  it "is created with an id, user_id " do
    station = PL::Station.new({ id: 12, user_id: 19 })
    expect(station.id).to eq(12)
    expect(station.user_id).to eq(19)
  end

  it "starts with a playlist that lasts through the next Thursday midnight" do



  end

end
