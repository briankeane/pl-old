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


    $('#file').on('change', function(e) { load(this); });
    $('#heavy').sortable();
    $('#songlist').sortable({ connectWith: ["#heavy", "#medium", "#light"],
                              dropOnEmpty: true });
    $('#heavy').sortable({ connectWith: ["#songlist", "#medium", "#light"],
                            dropOnEmpty: true });
    $('#medium').sortable({ connectWith: ["#heavy", "#songlist", "#light"],
                              dropOnEmpty: true });
    $('#light').sortable({   connectWith: ["#heavy", "#medium", "#songlist"],
                              dropOnEmpty: true,
                              receive: function(event, ui) {
                                ui.item.slice();
                              } });
    $('#searchText').keyup(function() {
      var allListElements = $('li');
      var fullList = $('#songlist li');
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
