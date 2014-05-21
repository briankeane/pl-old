require 'spec_helper'

module PL

  describe "GetNextSpin" do
    it "calls bullshit if spin is not found" do
      result = PL::GetNextSpin.run(99999)
      expect(result.success?).to eq(false)
      expect(result.error).to eq(:spin_not_found)
    end

    it "creates a user" do
      station = PL.db.create_station({ user_id: 1 })
      spin1 = PL.db.schedule_spin({ played_at: Time.now, station_id: station.id })
      spin2 = PL.db.schedule_spin({ current_position: 3, station_id: station.id })
      result = PL::GetNextSpin.run(station.id)
      expect(result.success?).to eq(true)
      expect(result.next_spin.id).to eq(spin2.id)
    end
  end
end
