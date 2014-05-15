var webAudio = function() {

  // see if any of these work (diff browsers)
  var contextClass = (window.AudioContext ||
                      window.webkitAudioContext ||
                      window.mozAudioContext ||
                      window.oAudioContext ||
                      window.msAudioContext);

  if (contextClass) {
    // webAudio is available so init it
    var context = new contextClass();
  } else {
    alert("You can't record with this browser... time to UPGRADE, bitch.");
  }

  var bufferLoader = new BufferLoader(
    context,
    [
    '../../../../Desktop/oldwithyou.mp3'
    ],
    finishedLoading
    );

  bufferLoader.load();
}

function finishedLoading(bufferList) {
  var source1 - context.createBufferSource();
  source1.buffer = bufferList[0];

  source1.connect(context.destination);
  source1.start(0);
}
