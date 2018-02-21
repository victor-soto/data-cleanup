(function($) {

  var form = {
    init: function() {
      this.bindEvents();
    },
    bindEvents: function() {
      var $base = $('body');
      $base.on('click', 'input.textFile[type="text"]', this.triggerFile);
      $('input:file', '.ui.action.input').on('change', this.updateNameFile);
    },
    triggerFile: function(e) {
      $(this).parent().find("input:file").click();
    },
    updateNameFile: function(e) {
      var name = e.target.files[0].name;
      $('input:text', $(e.target).parent()).val(name);
    }
  }

  form.init();

})(jQuery);