(function($) {

  var $upload = $('input.upload-temp');

  $upload.fileupload({
    url: '/documents/upload_temp',
    dataType: 'json',
    done: function (e, data) {
      var file = data.result.document;
      var selector = $(this).data('target');
      $(selector).val(file.id);
      console.log($(selector));
    }
  });

  var $preview = $('#preview-lookup');
  $preview.on('click', function() {
    var target = $(this).data('target');
    var source = $(this).data('source');
    var url = $(this).data('load');
    var payload = {csv_1: $(target).val(), csv_2: $(source).val()};
    $.ajax({
      url: url,
      data: payload,
      done: function(data) {
        console.log(data);
      }
    });
  });

})(jQuery);