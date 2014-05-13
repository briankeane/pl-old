/** @jsx React.DOM */

var djBooth = function () {
  // tutorial1.js
  jQuery(function() {
    jQuery("#tabs").tabs();
  });

  $(selector).on(action,function(){
    // example of 'data to send'
    swap = {
      oldPostion: 1,
      newPosition: 5
    };
    $.post('route', {swap: swap}, function(data) {
      // stuff you want to happen after the data has been sent to the server
    });

  });

  $("#songlist").sortable({
        items: ".scheduled_play",
        forcePlaceholderSize: true
    }).disableSelection();
    $(".commercial_block").sortable("option", "disabled", true);

};
