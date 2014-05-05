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
      expect(user.compare_password("password")).to eq(true)
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
    end

    it "creates a station" do
      expect(@station.user_id).to eq(@user.id)
      expect(@station.id).to_not be_nil
    end

    it "gets a station" do
      expect(db.get_station(@station.id).user_id).to eq(@user.id)
    end
  end
end
