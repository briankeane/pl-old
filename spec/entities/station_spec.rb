require 'spec_helper'
require 'timecop'

describe 'a station' do
  it "is created with an id, user_id " do
    station = PL::Station.new({ id: 12, user_id: 19 })
    expect(station.id).to eq(12)
    expect(station.user_id).to eq(19)
  end

  describe 'playlist functions' do

    before (:each) do
      Timecop.freeze(Time.local(2014, 5, 9, 10))
      @user = PL.db.create_user({ twitter: "Bob", password: "password" })
      @song = PL.db.create_song({ title: "Bar Lights", artist: "Brian Keane", album: "Coming Home", duration: 226000 })
      @station = PL.db.create_station({ user_id: @user.id, heavy: [@song] })
      @station.generate_playlist
    end

    it "creates a first playlist" do
      playlist = PL.db.get_full_playlist(@station.id)
      expect(playlist.size).to eq(4675)
    end

    it "estimates the end of the current playlist" do
      expect(PL.db.get_current_playlist(@station.id).size).to eq(4674)
      expect(@station.playlist_estimated_end_time.to_s).to match("2014-05-23 00:05:10")
    end

    it "extends the playlist by a week" do
      # go to tommorow and make sure running it again doesn't add anything -- it's already at the max
      Timecop.travel(2014, 5, 14, 10)
      @station.generate_playlist
      expect(PL.db.get_full_playlist(@station.id).size).to eq(4675)

      # but another week from now and it will...
      Timecop.travel(2014, 5, 15, 10)
      @station.generate_playlist
      expect(PL.db.get_full_playlist(@station.id).size).to eq(7083)
    end

    it "gets the new current playlist_estimated_end_time" do
      #@station.generate_playlist
      expect(@station.playlist_estimated_end_time.to_s).to match("2014-05-23 00:05:10")
    end


    describe "get_playlist_by_air_time" do
      it "gets a playlist by it's airtime" do
        playlist = @station.get_playlist_by_air_time(Time.new(2014, 5, 19, 6, 55))
        expect(playlist.size).to eq(34)
        expect(playlist[0].current_position).to eq(3773)
        expect(playlist.last.current_position).to eq(3802)
      end

      it "gets the next_song_start_time" do
        expect(@station.next_song_start_time.to_s).to match('2014-05-09 10:03:46')
      end
    end

    after(:all) do
      Timecop.return
    end
  end
end
