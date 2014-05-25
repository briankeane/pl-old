(function(){
  // (controller, action)
  if ($('body.station.playlist_editor').length) {

    /**
     * Copyright (c) 2010 António Afonso, antonio.afonso gmail, http://www.aadsm.net/
     * MIT License [http://www.opensource.org/licenses/mit-license.php]
     *
     */

    (function(ns) {
        ns["FileAPIReader"] = function(file, opt_reader) {
            return function(url, fncCallback, fncError) {
                var reader = opt_reader || new FileReader();

                reader.onload = function(event) {
                    var result = event.target.result;
                    fncCallback(new BinaryFile(result));
                };
                reader.readAsBinaryString(file);
            }
        };
    })(this);



    var louisQuery = function(e){return document.getElementById(e);};

    function loadUrl(url, callback, reader) {
        var startDate = new Date().getTime();
        ID3.loadTags(url, function() {
            var endDate = new Date().getTime();
            if (typeof console !== "undefined") console.log("Time: " + ((endDate-startDate)/1000)+"s");
            var tags = ID3.getAllTags(url);

            var formattedTags = { "artist": tags.artist.toString(),
                              "title": tags.title.toString(),
                              "album": tags.album.toString() }

            $.ajax({
              type: "GET",
              dataType: "json",
              url: 'songs/check_for_song',
              contentType: 'application/json',
              data: (formattedTags),
              success: function(obj) {
                return obj;
              },
              error : function(error) {
                console.log(error);
                debugger;
              }
            }).then(function(obj)
              {
                if (obj.exists == false) {
                  $('#songUpload').removeAttr('disabled');
                  $('#songMessage').text('');
                } else {
                  $('#songMessage').text('That song is already in the database');
                }
              });

            callback(tags);
            console.log(tags);
            console.log(tags.artist.toString());
            console.log(tags.title.toString());

          // if( callback ) {  };
        },
        {tags: ["artist", "title", "album", "year", "comment", "track", "genre", "lyrics", "picture"],
         dataReader: reader});
    }

    function loadFromLink(link) {
        var loading = link.parentNode.getElementsByTagName("img")[0];
        var url = link.href;

        loading.style.display = "inline";
        loadUrl(url, function() {
            loading.style.display = "none";
        });
    }

    function loadFromFile(file) {
        var url = file.urn ||file.name;
        loadUrl(url, function(tags) {

          console.log(tags["artist"]["[[PrimitiveValue]]"]);
          alert('hi');



        }, FileAPIReader(file));
    }

    function load(elem) {
        if (elem.id === "file") {
            loadFromFile(elem.files[0]);
        } else {
            loadFromLink(elem);
        }
    }

    function addToRotation(event, ui) {

      var addToRotationObject = {
                        "song_id": parseInt(ui.item.attr('data-id')),
                        "level": event.target.id
                                }
      addToRotationObject._method = 'POST'

      $.ajax({
              type: "POST",
              dataType: "json",
              url: 'station/add_to_rotation',
              contentType: 'application/json',
              data: JSON.stringify(addToRotationObject),
              success: function(obj) {
                return obj;
              },
              error : function(error) {
                console.log(error);
              }
            });
    }

    function deleteFromRotation(event, ui) {

      var deleteFromRotationObject = {
                        "song_id": parseInt(ui.item.attr('data-id')),
                        "level": event.target.id
                                }
      deleteFromRotationObject._method = 'POST'

      $.ajax({
              type: "DELETE",
              dataType: "json",
              url: 'station/delete_from_rotation',
              contentType: 'application/json',
              data: JSON.stringify(deleteFromRotationObject),
              success: function(obj) {
                return obj;
              },
              error : function(error) {
                console.log(error);
              }
            });
    }



    $('#file').on('change', function(e) { load(this); });
    $('#heavy').sortable();
    $('#all-songs-list').sortable({ connectWith: ["#heavy", "#medium", "#light"],
                              dropOnEmpty: true });
    $('#heavy').sortable({ connectWith: ["#all-songs-list", "#medium", "#light"],
                            dropOnEmpty: true,
                            receive: function(event, ui) {
                                addToRotation(event, ui);
                              },
                              remove: function(event, ui) {
                                deleteFromRotation(event, ui)
                              }  });
    $('#medium').sortable({ connectWith: ["#heavy", "#all-songs-list", "#light"],
                              dropOnEmpty: true,
                              receive: function(event, ui) {
                                addToRotation(event, ui);
                              },
                              remove: function(event, ui) {
                                deleteFromRotation(event, ui)
                              }
                              });
    $('#light').sortable({   connectWith: ["#heavy", "#medium", "#all-songs-list"],
                              dropOnEmpty: true,

                              receive: function(event, ui) {
                                addToRotation(event, ui);
                              },

                              remove: function(event, ui) {
                                deleteFromRotation(event, ui)
                              }

                              });
    $('#searchText').keyup(function() {
      var allListElements = $('li');
      var fullList = $('#all-songs-list li');
      var searchString = $('#searchText').val().toLowerCase();

      for (var i=0; i<fullList.length; i++) {
        var attr = fullList.eq(i).attr('data-searchString');
        if  (typeof attr !== 'undefined' && attr !== false) {
          var targetString = fullList.eq(i).attr("data-searchString").toLowerCase();

          if (targetString.indexOf(searchString) == -1) {
            fullList.eq(i).hide();
          } else {
            fullList.eq(i).show();
          }

        }
      }

    });



  }

})();
