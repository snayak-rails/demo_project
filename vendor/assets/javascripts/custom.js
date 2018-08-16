$(document).ready(function() {
  $(document).ajaxStart(function() {
    $.blockUI({ css: {
      border: 'none',
      padding: '15px',
      backgroundColor: 'transparent',
      '-webkit-border-radius': '10px',
      '-moz-border-radius': '10px',
      opacity: .5,
      zIndex: 10511,
      color: '#fff'
      },
      message: '<img src="http://localhost:3000//assets/icon.gif" />'
    });

    $(".blockOverlay").css("zIndex", "10511");
  });

  $(document).ajaxSuccess(function() {
    $.unblockUI();
  });
});
