/** @jsx React.DOM */

var djBooth = function () {
  // tutorial1.js
  jQuery(function() {
    jQuery("#tabs").tabs();
  });

  $("#songlist").sortable({
        items: ".scheduled_play",
        forcePlaceholderSize: true
    }).disableSelection();
    $(".content").disableSelection();

};
