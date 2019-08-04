// Confirmation message
$.rails.allowAction = function(link) {
  if (!link.attr('data-confirm')) {
    return true;
  }
  $.rails.showConfirmDialog(link);
  return false;
};

$.rails.confirmed = function(link) {
  link.removeAttr('data-confirm');
  return link.trigger('click.rails');
};

$.rails.showConfirmDialog = function(link) {
  var html, message_header, message, note, confirmation_button;
  message_header = link.attr('data-action-type');
  message = link.attr('data-confirm');
  note = link.attr('data-note') ? "<strong>Note: </strong>" + link.attr('data-note') : "" ;
  confirmation_button = link.attr('data-action') || "Confirm";
  cancel_button = link.attr('data-dismiss') || "Cancel";

  html = "<div class=\"modal\" id=\"confirmationDialog\">\n  <div class=\"modal-dialog\">\n    <div class=\"modal-content\">\n      <div class=\"modal-header bg-primary\">\n        <a class=\"close\" data-dismiss=\"modal\"><h4><strong>×</strong></h4></a>\n        <h4><strong>" + message_header + "</strong></h4>\n      </div>\n      <div class=\"modal-body\">\n        <h4>" + message + "</h4>\n        <br><h5>" + note + "</h5>\n      </div>\n      <div class=\"modal-footer\">\n        <a data-dismiss=\"modal\" class=\"btn cancel\">" + cancel_button + "</a>\n        <a data-dismiss=\"modal\" class=\"btn btn-danger confirm\">" + confirmation_button + "</a>\n      </div>\n    </div>\n  </div>\n</div>";

  $(html).modal();
  return $('#confirmationDialog .confirm').on('click', function() {
    return $.rails.confirmed(link);
  });
};

$( document ).ready(function() {
  if( $(".index-table").length!=0 ){ 
    if( $(".read-only-table").length!=0 ){
      $('table').on( 'click', 'tbody tr td', function () {
          window.location=($(this).parent().children("tr td:last").find("a:contains('Show')").attr('href'));
        });
    }
    else{
      if( $(".checkerbox").length==0 ){
        $('table').on( 'click', 'tbody tr td:not(:last-child)', function () {
          window.location=($(this).parent().children("tr td:last").find("a:contains('Show')").attr('href'));
        });
      }
      else{
        $('table').on( 'click', 'tbody tr td:not(:last-child, :first-child)', function () {
          window.location=($(this).parent().children("tr td:last").find("a:contains('Show')").attr('href'));
        });
      }
    }
  }
});

$(document).on("focus", "[data-behaviour~='datepicker']", function(e){
  $(this).datepicker({
    "format": "yyyy-mm-dd", 
    "weekStart": 1, 
    "forceParse":false, 
    "autoclose":true, 
    "defaultViewDate":"today", 
    "orientation": "bottom"
    }
  );
});

$(document).on("mouseover", "[data-toggle='tooltip']", function(e){
  $(this).tooltip();
});