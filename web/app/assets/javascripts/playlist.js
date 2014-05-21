(function(){
  // (controller, action)
  if ($('body.station.playlist_editor').length) {


    // MUCH OF THIS CODE IS ADAPTED FROM hayageek.com/drag-and-drop-file-upload-jquery



    function sendFileToServer(data, status) {
      var request = $.ajax({
        xhr: function() {
          var xhrobj = $.ajaxSettings.xhr();
          if (xhrobj.upload) {
            xhrobj.upload.addEventListener('progress', function(event) {
              var percent = 0;
              var position = event.loaded || event.position;
              var total = event.total;
              if (event.lengthComputable) {
                percent = Math.ceil(position / total * 100);
              }
              status.setProgress(percent);
            }, false);
          }
        return xhrobj;
        },
        url: 'song/create',
        type: "POST",
        contentType: false,
        processData: false,
        cache: false,
        data: data,
        success: function(receiveData){
          status.setProgress(100);
        }
      });
    status.setAbort(request);
    }

    var rowCount = 0;
    function createStatusBar(obj) {
      rowCount++;
      if (rowCount % 2 === 0) {
        var row = "even";
      } else {
        var row = "odd";
      }
      this.statusBar = $("<div class='statusBar " + row + "'></div>");
      this.filename = $("<div class='filename'></div>").appendTo(this.statusbar);
      this.size = $("<div class='filesize'></div>").appendTo(this.statusbar);
      this.progressBar = $("<div class='progressBar'><div></div></div>").appendTo(this.statusbar);
      this.abort = $("<div class='abort'>Abort</div>").appendTo(this.statusbar);
      obj.after(this.statusbar);

      this.setFileNameSize = function(name, size) {
        var sizeStr="";
        var sizeKB = size/1024;
        if (parseInt(sizeKB) > 1024) {
          var sizeMB = sizeKB/1024;
          sizeStr = sizeMB.toFixed(2) + " MB";
        } else {
          sizeStr = sizeKB.toFixed(2) + " KB";
        }

        this.filename.html(name);
        this.size.html(sizeStr);
      }
      this.setProgress = function(progress){
        var progressBarWidth = progress*this.progressBar.width()/100;
        this.progressBar.find('div').animate({ width: progressBarWidth} , 10).html(progress + "% ");
        if(parseInt(progress) >= 100) {
          this.abort.hide();
        }
      }
      this.setAbort = function(request) {
        var sb = this.statusBar;
        this.abort.click(function() {
          request.abort();
          sb.hide();
        });
      }
    }

    function handleFileUpload(files, obj) {
      for (var i=0; i < files.length; i++) {
        var fd = new FormData();
        fd.append('file', files[i]);

        var status = new createStatusBar(obj);
        status.setFileNameSize(files[i].name, files[i].size);
        sendFileToServer(fd, status);
      }
    }

    $(document).ready(function() {
      var obj = $('.all-songs');
      obj.on('dragenter', function(e) {
        e.stopPropagation();
        e.preventDefault();
        $(this).css('border', '5px solid #0B85a1');
      });

      obj.on('dragover', function(e) {
        e.stopPropagation();
        e.preventDefault();
      });

      obj.on('drop', function(e) {
        $(this).css('border', '2px solid black');
        e.preventDefault();
        debugger;
        var files = e.originalEvent.dataTransfer.files;

        handleFileUpload(files, obj);
      });

      $(document).on('dragenter', function (e) {
        e.stopPropagation();
        e.preventDefault();
      });

      $(document).on('dragover', function (e) {
        e.stopPropagation();
        e.preventDefault();
        obj.css('border', '2px dotted #0B85A1');
      });

      $(document).on('drop', function (e) {
        e.stopPropagation();
        e.preventDefault();
      });

    });

  }




})();
