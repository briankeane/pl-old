module PL
  class SeedDB
    def self.run
    #   PL.db.add_stored_songs_to_db
      # @@songs = PL.db.get_all_songs


      @@songs = []
      @@songs << PL.db.create_song({ title: "Keep Her Man", artist: "Cody Johnson", duration: 198504, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs << PL.db.create_song({ title: "What You're Missing", artist: "Brian Keane", duration: 241867, sing_start: 5000, sing_end: 208000,audio_id: 2 })
      @@songs << PL.db.create_song({ title: "A Different Day", artist: "Cody Johnson", duration: 250096, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs << PL.db.create_song({ title: "What You're Missing", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs << PL.db.create_song({ title: "Finally Free", artist: "Brian Keane", duration: 197851, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs << PL.db.create_song({ title: "Coming Home", artist: "Brian Keane", duration: 248868, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs << PL.db.create_song({ title: "Old With You", artist: "Brian Keane", duration: 168724, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs << PL.db.create_song({ title: "Do Something Wrong", artist: "Brian Keane", duration: 27459, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs << PL.db.create_song({ title: "Nothin' Short of Disaster", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Bar Lights", artist: "Brian Keane", duration: 226403, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Want Me Too", artist: "Charlie Worsham", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Young To See", artist: "Charlie Worsham", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Trouble Is", artist: "Charlie Worsham", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Rubberband", artist: "Charlie Worsham", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "How I Learned to Pray", artist: "Charlie Worsham", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Tools of the Trade(feat. Marty Stuart & Vince Gill", artist: "Charlie Worsham", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Mississippi in July", artist: "Charlie Worsham", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Break What's Broken", artist: "Charlie Worsham", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Someone Like Me", artist: "Charlie Worsham", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Love Don't Die Easy", artist: "Charlie Worsham", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Sleeping Like a Baby", artist: "Charlie Worsham", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Cold Cold Heart", artist: "Rachel Loy", duration: 190093, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Long Gone", artist: "Will Hoge", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "The Wreckage", artist: "Will Hoge", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Favorite Waste of Time", artist: "Will Hoge", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Even If it Breaks Your Heart", artist: "Will Hoge", duration: 221884, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "What Could I Do", artist: "Will Hoge", duration: 268826, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Goodnight / Goodbye", artist: "Will Hoge", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Just Like Me", artist: "Will Hoge", duration: 208430, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Highway Wings", artist: "Will Hoge", duration: 204120, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Where Do We Go From Down", artist: "Will Hoge", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Too Late Too Soon", artist: "Will Hoge", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Fade to Gray", artist: "Rachel Loy", duration: 275931, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Stepladder", artist: "Rachel Loy", duration: 222223, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Standing By the Rambler", artist: "Brian Keane", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "White Liar", artist: "Miranda Lambert", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Only Prettier", artist: "Miranda Lambert", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Dead Flowers", artist: "Miranda Lambert", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Me and Your Cigarettes", artist: "Miranda Lambert", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Maintain the Pain", artist: "Miranda Lambert", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "The House that Built Me", artist: "Miranda Lambert", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Interstate", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Buy Myself a Chance", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Tonight's Not the Night", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Better off Wrong", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Speak of the Devil", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Flash Flood", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "This Time Around", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "If I Had Another Heart", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Last Last Chance", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "One More Goodbye", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Somebody Take Me Home", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Ten Miles Deep", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Too Late For Goodbye", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "In My Arms Instead", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Fuzzy", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Can't Slow Down", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Like It Used To Be", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "They Call it the Hill Country", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Down and Out", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Never Be That High", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Lonely Too Long", artist: "Randy Rogers Band", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Hey Cara", artist: "Rachel Loy", duration: 212480, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Saturday Night", artist: "Wade Bowen", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Trouble", artist: "Wade Bowen", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "If We Ever Make it Home", artist: "Wade Bowen", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Nobody's Fool", artist: "Wade Bowen", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@songs <<  PL.db.create_song({ title: "Mood Ring", artist: "Wade Bowen", duration: 226000, sing_start: 5000, sing_end: 208000, audio_id: 2 })
      @@user1 = PL.db.create_user({ twitter: 'BrianKeaneTunes', password: 'password', email: 'bob@bob.com' })
      @@user2 = PL.db.create_user({ twitter: 'bob', password: 'password', email: 'bob@bob.com' })
      @@user3 = PL.db.create_user({ twitter: 'bob2', password: 'password', email: 'bob@bob.com' })
      @@user4 = PL.db.create_user({ twitter: 'bob3', password: 'password', email: 'bob@bob.com' })
      @@user5 = PL.db.create_user({ twitter: 'bob4', password: 'password', email: 'bob@bob.com' })
      @@station1 = PL.db.create_station({ user_id: @@user1.id })


      ## add appropriate # of random heavy rotation songs
      counter = 0
      used = {}
      while counter <= 12
        random_song = @@songs.sample
        if !used[random_song.id]
          PL.db.create_rotation_level({ station_id: @@station1.id, song_id: random_song.id, level: "heavy" })
          @@station1 = PL.db.get_station(@@station1.id)
          used[random_song.id] =  random_song
          counter += 1
        end
      end

      ## medium songs
      counter = 0
      while counter <= 29
        random_song = @@songs.sample
        if !used[random_song.id]
          PL.db.create_rotation_level({ station_id: @@station1.id, song_id: random_song.id, level: "medium" })
          @@station1 = PL.db.get_station(@@station1.id)
          used[random_song.id] =  random_song
          counter += 1
        end
      end

      ## the rest go in light
      @@songs.each do |song|
        if !used[song.id]
          PL.db.create_rotation_level({ station_id: @@station1.id, song_id: random_song.id, level: "light" })
          @@station1 = PL.db.get_station(@@station1.id)
        end
      end



      @@station2 = PL.db.create_station({ user_id: @@user2.id })
      @@station3 = PL.db.create_station({ user_id: @@user3.id })
      @@station4 = PL.db.create_station({ user_id: @@user4.id })
      @@station5 = PL.db.create_station({ user_id: @@user5.id })


      # load up a station and make it so it's been playing a little while
      Timecop.travel(Time.local(2014, 5, 9, 10))
      Array.any_instance.stub(:sample).and_return(@@songs[0])
      @@station1.generate_playlist
      stubbed_current_time = Time.local(2014, 5, 11, 10)
      Timecop.travel(stubbed_current_time)
      playlist = PL.db.get_full_playlist(@@station1.id)
      1000.times do |i|
        stubbed_current_time += 208
        Timecop.travel(stubbed_current_time)
        PL.db.record_spin_time({ spin_id: playlist[i].id, played_at: Time.now })
      end
    end

    def self.station1
      @@station1
    end

    def self.song1
      @@songs[0]
    end
  end
end
