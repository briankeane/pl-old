require 'spec_helper'
require 'timecop'
require 'pry-debugger'

describe 'a station' do
  it "is created with an id, user_id " do
    station = PL::Station.new({ id: 12, user_id: 19 })
    expect(station.id).to eq(12)
    expect(station.user_id).to eq(19)
  end

  describe 'playlist functions' do

    before (:all) do
      Timecop.travel(Time.local(2014, 5, 9, 10))
      PL::SeedDB.run
      @station = PL::SeedDB.station1
    end

    it "creates a first playlist" do
      #stub stuff
      Array.any_instance.stub(:sample).and_return(PL::SeedDB.song1)
      @station.generate_playlist
      playlist = PL::Database.db.get_full_playlist(@station.id)
      expect(playlist.size).to eq(4675)
    end


    it "estimates the end of the current playlist" do
      Timecop.travel(Time.local(2014, 5, 9, 10))
      playlist = PL::Database.db.get_full_playlist(@station.id)
      stubbed_current_time = Time.local(2014, 5, 11, 10)
      Timecop.travel(stubbed_current_time)
      1000.times do |i|
        stubbed_current_time += 208
        Timecop.travel(stubbed_current_time)
        PL::Database.db.record_spin_time({ spin_id: playlist[i].id, played_at: Time.now })
      end

      expect(PL::Database.db.get_current_playlist(@station.id).size).to eq(3675)
      expect(@station.playlist_estimated_end_time.to_s).to eq('2014-05-24 12:11:56 -0500')
    end

    it "extends the playlist by a week" do
      # go to tommorow and make sure running it again doesn't add anything -- it's already at the max
      Timecop.travel(2014, 5, 14, 10)
      @station.generate_playlist
      expect(PL::Database.db.get_full_playlist(@station.id).size).to eq(4675)

      # but another week from now and it will...
      Timecop.travel(2014, 5, 15, 10)
      @station.generate_playlist
      expect(PL::Database.db.get_full_playlist(@station.id).size).to eq(6566)
    end

    it "gets the current playlist_estimated_end_time" do
      expect(@station.playlist_estimated_end_time.to_s).to eq(Time.new(2014,5,30,0, 6, 42).to_s)
    end


    describe "get_playlist_by_air_time" do
      it "gets a playlist by it's airtime" do
        playlist = @station.get_playlist_by_air_time(Time.new(2014, 5, 19, 6, 55))
        expect(playlist.size).to eq(34)
        expect(playlist[0].current_position).to eq(3087)
        expect(playlist.last.current_position).to eq(3116)
      end
    end

    after (:all) do
      Timecop.return
    end
  end
end
