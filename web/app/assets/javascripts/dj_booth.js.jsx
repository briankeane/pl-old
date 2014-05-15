/** @jsx React.DOM */

var djBooth = function () {
  // sets up tabs
  jQuery(function() {
    jQuery("#tabs").tabs();
  });

  // $(selector).on(action,function(){
  //   // example of 'data to send'
  //   swap = {
  //     oldPostion: 1,
  //     newPosition: 5
  //   };
  //   $.post('route', {swap: swap}, function(data) {
  //     // stuff you want to happen after the data has been sent to the server
  //   });

  // });


  $("#songlist").sortable({
                        items: ".scheduled_play",
                        forcePlaceholderSize: true
                          });

  $("#songProgressbar").progressbar({
                            value: currentSpin,
                            max: currentSpin["audio_block"]["duration"]
                                    });

  $("#options-tabs").tabs({ active: 1 });



  var updateCurrentSpins = function() {
    currentSpin = playlist.shift();
    currentSpin["played_at"] = new Date();
    $('#songlist li').first().remove();
    $('#now_playing .title').text(currentSpin["audio_block"]["title"]);
    $('#now_playing .artist').text(currentSpin["audio_block"]["artist"]);
    $("#songProgressbar").progressbar({
      value: 0,
      max: (currentSpin["audio_block"]["duration"])
      });
  }




  // set up a function to update all timers
  var updateTimers = function() {
    var msElapsed = +new Date() - +currentSpin["played_at"];
    $('#elapsed_time').text(formatSongFromMS(msElapsed));
    $('#time_remaining').text(formatSongFromMS(currentSpin["audio_block"]["duration"] - msElapsed));
    if (msElapsed >= currentSpin["audio_block"]["duration"]) {
      updateCurrentSpins();
    }
    $('#songProgressbar').progressbar({
      value: msElapsed
    });
  }


  // update all clocks and timers
  setInterval(function () { updateTimers() }, 1000);

};


