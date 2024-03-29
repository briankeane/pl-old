require 'spec_helper'
require 'Timecop'

shared_examples 'a badass database' do

  let(:db) { described_class.new("test") }

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

    it 'updates a user' do
      user = db.create_user ({ twitter: "bob", password: "password", email: "bob@bob.com" })
      db.update_user({ id: user.id, twitter: "bill" })
      updated_user = db.get_user(user.id)
      expect(updated_user.twitter).to eq("bill")
    end

  end

  ##############
  #   Songs    #
  ##############

  ############################################################################
  #
  #            TALK TO GILBERT -- NEED A WAY TO TEST CREATE_SONG FILE
  #
  #############################################################################


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

    it "finds out if a song exists" do
      song = db.create_song({ title: "Bar Lights", artist: "Brian Keane", album: "Coming Home", duration: 226000, sing_start: 5000, sing_end: 208000,
                                                          audio_id: 2 })
      expect(db.song_exists?({ title: "Bar Lights", artist: "Brian Keane", album: "Coming Home"})).to eq(true)
      expect(db.song_exists?({ title: "Bar Nights", artist: "Brian Keane", album: "Coming Home"})).to eq(false)
      expect(db.song_exists?({ title: "Bar Lights", artist: "Krian Beane", album: "Coming Home"})).to eq(false)
      expect(db.song_exists?({ title: "Bar Lights", artist: "Brian Keane", album: "Going falseHome"})).to eq(false)
    end

    it "gets a song" do
      song = db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                                          audio_id: 2 })
      expect(db.get_song(song.id).title).to eq("Bar Lights")
    end


    before do
      @song1 = db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
      @song2 = db.create_song({ title: "Bar Nights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
      @song3 = db.create_song({ title: "Bar Brights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
      @song4 = db.create_song({ title: "Bar First", artist: "Bob Dylan", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
      @song5 = db.create_song({ title: "Hell", artist: "Bob Dylan", duration: 226000, sing_start: 5000, sing_end: 208000,
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

    it "updates a song" do
      updated_song1 = db.update_song({ id: @song1.id, title: "Bar Days" })
      expect(updated_song1.title).to eq("Bar Days")
    end

    it "returns a list of all songs in the database in the proper order" do
      all_songs = db.get_all_songs
      expect(all_songs.size).to eq(5)
      expect(all_songs[0].title).to eq("Bar First")
      expect(all_songs[1].title).to eq("Hell")
      expect(all_songs[2].title).to eq("Bar Brights")
      expect(all_songs[3].title).to eq("Bar Lights")
      expect(all_songs[4].title).to eq("Bar Nights")
    end

    xit "returns the audio file for a song" do
    end



  end

  ####################
  # Commercial Block #
  ####################
  describe 'CommercialBlock' do
    it "creates a commercial block" do
      commercial = db.create_commercial_block
      expect(commercial.id).to_not be_nil
    end

    it "gets a commercial block" do
      commercial = db.create_commercial_block
      expect(db.get_commercial_block(commercial.id).id).to eq(commercial.id)
    end
  end


  ##############
  #   Station  #
  ##############

  describe 'a station' do
    before do
      @user = db.create_user ({ twitter: "bob", password: "password", email: "bob@bob.com" })
      @song = db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
      @station = db.create_station({ user_id: @user.id, heavy: [@song], medium: [@song], light: [@song] })

    end

    it "creates a station" do
      expect(@station.user_id).to eq(@user.id)
      expect(@station.id).to_not be_nil
    end

    it "updates the song rotation list" do
      expect(db.get_station(@station.id).heavy[0].id).to eq(@song.id)
      expect(db.get_station(@station.id).medium[0].id).to eq(@song.id)
      expect(db.get_station(@station.id).light[0].id).to eq(@song.id)
    end

    it "gets a station" do
      expect(db.get_station(@station.id).user_id).to eq(@user.id)
    end

    it "gets a station by user_id" do
      expect(db.get_station_by_uid(@user.id).id).to eq(@station.id)
    end
  end


    ####################
    #        Spin      #
    ####################

  describe 'Spin' do

    before do
      @user = db.create_user ({ twitter: "bob", password: "password", email: "bob@bob.com" })
      @song1 = db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
      @song2 = db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
      @song3 = db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
      @song4 = db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
      @song5 = db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
      @song6 = db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000,
                                   audio_id: 2 })
      @station = db.create_station({ user_id: @user.id, heavy: [@song1], medium: [@song2], light: [@song3] })

      @spin1 = db.schedule_spin({ station_id: @station.id, audio_block: @song1, current_position: 5 })
      @spin2 = db.schedule_spin({ station_id: @station.id, audio_block: @song2, current_position: 6 })
      @spin3 = db.schedule_spin({ station_id: @station.id, audio_block: @song3, current_position: 7 })
      @spin4 = db.schedule_spin({ station_id: @station.id, audio_block: @song4, current_position: 8 })
      @spin5 = db.schedule_spin({ station_id: @station.id, audio_block: @song5, current_position: 9 })
      @spin6 = db.schedule_spin({ station_id: @station.id, audio_block: @song6, current_position: 10 })
      @spin1 = db.record_spin_time({spin_id: @spin1.id, played_at: Time.local(2014, 5, 9, 9, 30) })
      @spin2 = db.record_spin_time({spin_id: @spin2.id, played_at: Time.local(2014, 5, 9, 9, 33) })
    end


    it "get_current_playlist returns not-yet-played spins in the right order" do
      expect(db.get_current_playlist(@station.id).size).to eq(4)
      expect(db.get_current_playlist(@station.id)[0].current_position).to eq(7)
      expect(db.get_current_playlist(@station.id)[2].current_position).to eq(9)
      expect(db.get_current_playlist(@station.id)[3].current_position).to eq(10)
    end

    it "gets a spin by current_position & station_id" do
      expect(db.get_spin_by_station_id_and_current_position({ station_id: @station.id, current_position: 5 }).id).to eq(@spin1.id)
    end

    it "creates a playlist and returns the entire thing" do
      expect(db.get_full_playlist(@station.id).size).to eq(6)
    end

    it "gets past spins" do
      expect(db.get_past_spins(@station.id).size). to eq(2)
      expect(db.get_past_spins(@station.id)[0].id).to eq(@spin1.id)
      expect(db.get_past_spins(@station.id)[1].id).to eq(@spin2.id)
    end

    it "gets the next song and records a spin time" do
      result = db.get_next_spin(@station.id)
      expect(result.current_position).to eq(7)

      db.record_spin_time({ spin_id: result.id, played_at: Time.local(2014, 5, 9, 9, 36) })
      new_result = db.get_next_spin(@station.id)
      expect(new_result.current_position).to eq(8)
    end

    it "gets the song currently being played" do
      result = db.get_current_spin(@station.id)
      expect(result.current_position).to eq(6)
      db.record_spin_time({ spin_id: @spin3.id, played_at: Time.local(2014, 5, 9, 9, 36) })
      expect(db.get_current_spin(@station.id).current_position).to eq(7)
    end

    it "moves a song backwards and adjusts the playlist around it" do
      db.move_spin({ old_position: 9, new_position: 7, station_id: @station.id })
      new_playlist = db.get_current_playlist(@station.id)
      expect(new_playlist.map { |spin| spin.audio_block.id }).to eq([@song5.id,@song3.id,@song4.id,@song6.id])
    end

    it "moves a song forwards and adjusts the playlist around it" do
      db.move_spin({ old_position: 7, new_position: 9, station_id: @station.id })
      new_playlist = db.get_current_playlist(@station.id)
      expect(new_playlist.map { |spin| spin.audio_block.id }).to eq([@song4.id,@song5.id,@song3.id,@song6.id])
    end

    # it "inserts a spin" do
    #   Timecop.travel(Time.local(2014, 5, 9, 9, 34))
    #   @station.generate_playlist
    #   db.insert_spin({ station_id: @station.id, insert_position: 55, audio_block: @song6 })
    #   expect(db.get_current_playlist).to eq([])
    #   Timecop.return
    # end


    ###################
    #  RotationLeveL  #
    ###################
    it 'creates a rotationLevel' do
      rotationlevel = db.create_rotation_level({ station_id: @station.id, song_id: @song1.id, level: "heavy" })
      expect(db.get_station(@station.id).heavy.map { |song| song.id }.include?(@song1.id)).to eq(true)
    end

    it 'deletes a rotationLevel' do
      expect(db.get_station(@station.id).heavy.map { |song| song.id }.include?(@song1.id)).to eq(true)
      rotationlevel = db.delete_rotation_level({ station_id: @station.id, song_id: @song1.id, level: "heavy" })
      expect(db.get_station(@station.id).heavy.map { |song| song.id }.include?(@song1.id)).to eq(false)
    end

  end

  ##############
  #  Sessions  #
  ##############
  describe 'Session' do
    it 'creates a Session' do
      user = db.create_user( twitter: 'jimmy', password: 'password')
      session_id = db.create_session(user.id)
      user_id = db.get_uid_from_sid(session_id)
      expect(user_id).to eq(user.id)
      expect(db.get_uid_from_sid("999999")).to be_nil
    end

    it 'deletes a session' do
      session_id = db.create_session(5)
      expect(db.get_uid_from_sid(session_id)).to eq(5)
      db.delete_session(session_id)
      expect(db.get_uid_from_sid(session_id)).to be_nil
    end
  end
end
