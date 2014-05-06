require 'spec_helper'

describe 'a badass database' do

  db = PL::Database::InMemory.new

  before { db.clear_everything }

  ##############
  #   Users    #
  ##############
  describe 'User' do
    it 'creates a User' do
      user = db.create_user ({ twitter: "bob", password: "password", email: "bob@bob.com" })
      expect(user.twitter).to eq("bob")
      expect(user.password_correct?("password")).to eq(true)
      expect(user.id).to_not be_nil
    end

    it 'gets a User' do
      user = db.create_user ({ twitter: "bob", password: "password", email: "bob@bob.com" })
      expect(db.get_user(user.id).twitter).to eq("bob")
    end

    it 'deletes a User' do
      user = db.create_user ({ twitter: "bob", password: "password", email: "bob@bob.com" })
      result = db.delete_user(user.id)
      expect(db.delete_user(999999)).to eq(false)
      expect(result).to eq(true)
      expect(db.get_user(user.id)).to be_nil
    end

    it 'gets a user by twitter' do
      user = db.create_user ({ twitter: "bob", password: "password", email: "bob@bob.com" })
      expect(db.get_user_by_twitter("bob").id).to eq(user.id)
      expect(db.get_user_by_twitter("billy")).to be_nil
    end
  end

  ##############
  #   Songs    #
  ##############

  describe 'Song' do
    it "is created with title, duration, sing_start, sing_end, artist, id, audio_id" do
      song = db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                                          audio_id: 2 })
      expect(song.title).to eq("Bar Lights")
      expect(song.artist).to eq("Brian Keane")
      expect(song.duration).to eq(226000)
      expect(song.sing_start).to eq(5000)
      expect(song.sing_end).to eq(208000)
      expect(song.id).to be_a(Fixnum)
      expect(song.audio_id).to eq(2)
    end

    it "gets a song" do
      song = db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                                          audio_id: 2 })
      expect(db.get_song(song.id).title).to eq("Bar Lights")
    end


    before do
      song1 = db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
      song2 = db.create_song({ title: "Bar Nights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
      song3 = db.create_song({ title: "Bar Brights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
      song4 = db.create_song({ title: "Bar First", artist: "Bob Dylan", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
      song5 = db.create_song({ title: "Hell", artist: "Bob Dylan", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
    end

    it "gets a list of songs by title" do
      songlist = db.get_songs_by_title("Bar")
      expect(songlist.size).to eq(4)
      expect(songlist[0].title).to eq("Bar Brights")
      expect(songlist[3].title).to eq("Bar Nights")
    end

    it "gets a list of songs by artist" do
      songlist = db.get_songs_by_artist("Brian Keane")
      expect(songlist.size).to eq(3)
      expect(songlist[0].title).to eq("Bar Brights")
      expect(songlist[2].title).to eq("Bar Nights")
    end
  end

  ##############
  #   Station  #
  ##############

  describe 'a station' do
    before do
      @user = db.create_user ({ twitter: "bob", password: "password", email: "bob@bob.com" })
      @station = db.create_station({ user_id: @user.id })
      @song = db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })

    end

    it "creates a station" do
      expect(@station.user_id).to eq(@user.id)
      expect(@station.id).to_not be_nil
    end

    it "gets a station" do
      expect(db.get_station(@station.id).user_id).to eq(@user.id)
    end

    ####################
    #  Scheduled Play  #
    ####################

    it "returns an empty array for an empty playlist" do
      playlist = db.get_current_playlist(@station.id)
      expect(playlist.size).to eq(0)
    end

    it "creates a playlist and return it in the right order" do
      db.schedule_play({ station_id: @station.id, song: @song, current_position: 5 })
      db.schedule_play({ station_id: @station.id, song: @song, current_position: 6 })
      db.schedule_play({ station_id: @station.id, song: @song, current_position: 7 })
      db.schedule_play({ station_id: @station.id, song: @song, current_position: 8 })
      db.schedule_play({ station_id: @station.id, song: @song, current_position: 9 })
      db.schedule_play({ station_id: @station.id, song: @song, current_position: 10 })
      expect(db.get_current_playlist(@station.id).size).to eq(6)
      expect(db.get_current_playlist(@station.id)[0].current_position).to eq(5)
      expect(db.get_current_playlist(@station.id)[4].current_position).to eq(9)
      expect(db.get_current_playlist(@station.id)[5].current_position).to eq(10)
    end

    ##############
    #  Sessions  #
    ##############
    describe 'Session' do
      it 'creates a Session' do
        session_id = db.create_session(5)
        user_id = db.get_uid_from_sid(session_id)
        expect(user_id).to eq(5)
        expect(db.get_uid_from_sid(25)).to be_nil
      end


      it 'deletes a session' do
        session_id = db.create_session(5)
        expect(db.get_uid_from_sid(session_id)).to eq(5)
        db.delete_session(session_id)
        expect(db.get_uid_from_sid(session_id)).to be_nil
      end

    end




  end

end
