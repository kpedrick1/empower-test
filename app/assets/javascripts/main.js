requirejs.config({
  enforceDefine: true,
  paths: {
    jquery: [
      'http://ajax.googleapis.com/ajax/libs/jquery/1.8.2/jquery.min',
      'jquery-1.8.2.min'
    ],
    "jquery-ui": 'jquery-ui.min'
  }
});

define(['jquery'], function ($) {
  $(function () {

    if ($('#accordions').length) {
      require(['jquery-ui'], function () {
          // Initialize accordion
          $( "#accordions" ).accordion({
            collapsible: true,
            active: false,
            heightStyle: "content"
          });
          // Open specified accordion item based on fragment passed into URL
          setTimeout(function () {
            if (window.location.hash) {
              var hash = window.location.hash.substring(1);
              if (hash === "patient") {
                $("#accordions h3").eq(1).trigger('click');
              } else if (hash === "physician") {
                $("#accordions h3").eq(0).trigger('click');
              }
            }
          }, 500);
          // Open register links in new window
          $('.register, .enroll').on('click', function () {
            window.open($('a', this).attr('href'), '_blank');
          });
      });
    }

    if ($('form').length) {
      require(['parsley'], function (parsley) {

        $parsleyForm = $('#patient-enrollment').parsley();
        $('.close').on('click', function () {
          $('.alert').addClass('no-alert');
        });
        $('.patient-enroll').on('click', function (e) {
          e.preventDefault();
          $parsleyForm.validate();
          if ($parsleyForm.isValid()) {
            $.post('/include/patient-enroll-process.php', $("#patient-enrollment").serialize(), function (data) {
              $('.alert').removeClass('alert-danger');
              $('.alert').removeClass('no-alert');
              $('.alert').addClass('alert-success');
              $('#status').html('The form has submitted successfully!');
            }).error(function (xhr, error, text) {
              $('.alert').removeClass('alert-success');
              $('.alert').removeClass('no-alert');
              $('.alert').addClass('alert-danger');
              $('#status').html('Error: ' + text);
            });
          }
          return false;
        });
      });
    }
  }); // End of Document ready
}); // End of define

