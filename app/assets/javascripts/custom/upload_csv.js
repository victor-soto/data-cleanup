(function($){ 
  console.log('asdf');
  'use strict';

  var uploader = {
    init: function() {
      $('#upload-csv-form').on('submit', self.sendFom);
      console.log($('#upload-csv-form'));
    },
    sendFom: function(e) {
      e.preventDefault();
      console.log('asdasf');
    }
  }

  uploader.init();
})(jQuery);