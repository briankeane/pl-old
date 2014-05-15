/** @jsx React.DOM */




(function(){
  // (controller, action)
  if ($('body.station.dj_booth').length) {


    // everything goes here

    $(".progress-bar").attr("aria-valuenow", +new Date() - +currentSpin["played_at"]);
    $(".progress-bar").attr("aria-valuemax", currentSpin["audio_block"]["duration"]);
    $(".progress-bar").css("width", (((+new Date() - +currentSpin["played_at"])/currentSpin["audio_block"]["duration"]) * 100) + "%");
    $("#options-tabs").tabs({ active: 1 });



    var updateCurrentSpins = function() {
      currentSpin = playlist.shift();
      currentSpin["played_at"] = new Date();
      $('#songlist li').first().remove();
      $('#now_playing .title').text(currentSpin["audio_block"]["title"]);
      $('#now_playing .artist').text(currentSpin["audio_block"]["artist"]);
      $(".progress-bar").attr("aria-valuenow", "0");
      $(".progress-bar").attr("aria-valuemax", currentSpin["audio_block"]["duration"]);
      $(".progress-bar").css("aria-valuenow", "0");
    }


    // set up a function to update all timers
    var updateTimers = function() {
      var msElapsed = +new Date() - +currentSpin["played_at"];
      $('#elapsed_time').text(formatSongFromMS(msElapsed));
      $('#time_remaining').text(formatSongFromMS(currentSpin["audio_block"]["duration"] - msElapsed));
      if (msElapsed >= currentSpin["audio_block"]["duration"]) {
        updateCurrentSpins();
      }
      $('.progress-bar').attr("aria-valuenow", msElapsed);
      $(".progress-bar").css("width", (((+new Date() - +currentSpin["played_at"])/currentSpin["audio_block"]["duration"]) * 100) + "%");
    }


  // update all clocks and timers
  setInterval(function () { updateTimers() }, 200);

  };




})();
