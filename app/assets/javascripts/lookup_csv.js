(function($) {

  var $upload = $('input.upload-temp');

  $upload.fileupload({
    url: '/documents/upload_temp',
    dataType: 'json',
    done: function (e, data) {
      var file = data.result.document;
      var $input = $(this);
      var selectorId = $input.data('target-id');
      console.log($input);
      console.log(selectorId);
      $(selectorId).val(file.id);
      var url = $(this).data('load');
      var payload = { id: file.id };
      $.ajax({
        url: url,
        data: payload,
        success: function(data) {
          valueRegex = new RegExp('{{value}}');
          target = $input.data('target');
          html = '';
          $(target).find('option').remove().end();
          $.each(data.csv_headers, function(idx, val) {
            var template = '<option value="{{value}}">{{value}}</option>';
            template = template.replace(valueRegex, val);
            html += template.replace(valueRegex, val);
          });
          $(target).append(html);
        }
      });
    }
  });

})(jQuery);
