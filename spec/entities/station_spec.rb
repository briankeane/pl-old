require 'spec_helper'
require 'timecop'
require 'pry-debugger'

describe 'a station' do
  it "is created with an id, user_id " do
    station = PL::Station.new({ id: 12, user_id: 19 })
    expect(station.id).to eq(12)
    expect(station.user_id).to eq(19)
  end

  describe 'playlist generation' do
    before do
      Timecop.travel(Time.local(2014, 5, 9, 10))
      PL::SeedDB.run
      @station = PL::SeedDB.station1
    end

    it "creates a first playlist" do
      #stub stuff
      Array.any_instance.stub(:sample).and_return(PL::SeedDB.song1)
      @station.generate_first_playlist
      playlist = PL::Database.db.get_full_playlist(@station.id)
      expect(playlist.size).to eq(2589)
      expect(playlist[8].audio_block).to be_a(PL::CommercialBlock)
    end

    it "won't generate_first_playlist twice" do
      @station.generate_first_playlist
      expect(@station.generate_first_playlist).to eq(false)
    end

    it "extends the playlist by a week" do
      @station.generate_first_playlist
      stubbed_current_time = Time.local(2014, 5, 11, 10)
      Timecop.travel(stubbed_current_time)

      playlist = PL::Database.db.get_full_playlist(@station.id)

      1000.times do |i|
        stubbed_current_time += 208
        Timecop.travel(stubbed_current_time)
        PL::Database.db.record_spin_time({ spin_id: playlist[i].id, played_at: Time.now })
      end

      expect(PL::Database.db.get_current_playlist(@station.id).size).to eq(1589)
      @station.generate_playlist

      expect(PL::Database.db.get_full_playlist(@station.id).size).to eq(4601)

      # go to tommorow and make sure running it again doesn't add anything -- it's already at the max
      Timecop.travel(2014, 5, 14, 10)
      @station.generate_playlist
      expect(PL::Database.db.get_full_playlist(@station.id).size).to eq(4601)

      # but another week from now and it will...
      Timecop.travel(2014, 5, 15, 10)
      @station.generate_playlist
      expect(PL::Database.db.get_full_playlist(@station.id).size).to eq(7346)


    end














    after do
      Timecop.return
    end
  end
end
