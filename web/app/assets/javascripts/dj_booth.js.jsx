/** @jsx React.DOM */




(function(){
  // (controller, action)
  if ($('body.station.dj_booth').length) {


    // initializations
    $(".progress-bar").attr("aria-valuenow", +new Date() - +currentSpin["played_at"]);
    $(".progress-bar").attr("aria-valuemax", currentSpin["audio_block"]["duration"]);
    $(".progress-bar").css("width", (((+new Date() - +currentSpin["played_at"])/currentSpin["audio_block"]["duration"]) * 100) + "%");
    $("#options-tabs").tabs({ active: 1 });
    $('#songlist').sortable({
        start: function(event, ui) {
          ui.item.startPos = ui.item.index();
          console.log($('#songlist').toArray());
        },
        stop: function(event, ui) {

          console.log("Start position: " + ui.item.startPos);
          console.log("New position: " + ui.item.index());

          // return if order did not change
          if (ui.item.startPos === ui.item.index()) { return; }

          // create an array with the just the song current_ids
          currentPositions = [];

          $('#songlist li').each( function(index, data) {
            if ($(this).hasClass('song')) {
              currentPositions.push($(this).attr("data-id"));
            }
          });
          console.log(currentPositions);

          // iterate through the array to find the out of place number
          var currentPositionCounter = currentPositions[0]-1;
          var oldPositionCounter = null;
          var newPositionCounter = null;
          var movePositionData = {};

          for (var i in currentPositions) {
            currentPositionCounter++;
            if (currentPositions[i] != currentPositionCounter) {
              if (!(movePositionData.hasOwnProperty('oldPosition'))) {  // if we haven't come across anything yet
                if (currentPositions[i] == currentPositionCounter + 1) { // if there's one missing
                  movePositionData.oldPosition = currentPositionCounter;
                  currentPositionCounter++;
                } else {  // otherwise store both positions and break
                  movePositionData.newPosition = currentPositionCounter;
                  movePositionData.oldPosition = currentPositions[i];
                  break;
                }
              } else {  // (if we've already stored oldPosition and are just looking for newPosition)
                movePositionData.newPosition = currentPositionCounter - 1;
                break;
              }
            }
          }

          console.log("oldPosition: " + movePositionData.oldPosition);
          console.log("newPosition: " + movePositionData.newPosition);

          // make ajax request to update database
          // update list
          currentPositionCounter = Math.min.apply(Math, currentPositions);
          $('#songlist li').each( function(index, data) {
            if ($(this).hasClass('song')) {
             $(this).attr("data-id", currentPositionCounter.toString());
            }
            currentPositionCounter++;
          });
        }
      });

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
      $('.progress-bar').css("width", (((+new Date() - +currentSpin["played_at"])/currentSpin["audio_block"]["duration"]) * 100) + "%");
    }


  // update all clocks and timers
  setInterval(function () { updateTimers() }, 200);

  };




})();
