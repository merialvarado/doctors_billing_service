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
  confirmation_button = link.attr('data-action');
  cancel_button = link.attr('data-dismiss');

  html = "<div class=\"modal\" id=\"confirmationDialog\">\n  <div class=\"modal-dialog\">\n    <div class=\"modal-content\">\n      <div class=\"modal-header bg-primary\">\n        <a class=\"close\" data-dismiss=\"modal\"><h4><strong>×</strong></h4></a>\n        <h4><strong>" + message_header + "</strong></h4>\n      </div>\n      <div class=\"modal-body\">\n        <h4>" + message + "</h4>\n        <br><h5>" + note + "</h5>\n      </div>\n      <div class=\"modal-footer\">\n        <a data-dismiss=\"modal\" class=\"btn cancel\">" + cancel_button + "</a>\n        <a data-dismiss=\"modal\" class=\"btn btn-danger confirm\">" + confirmation_button + "</a>\n      </div>\n    </div>\n  </div>\n</div>";

  $(html).modal();
  return $('#confirmationDialog .confirm').on('click', function() {
    return $.rails.confirmed(link);
  });
};

$( document ).ready(function() {
  $('.dataTable').DataTable({
    "dom": '<"top"<"dt-row"<"col-sm-6 new-button"><"col-sm-6" f>><"dt-row"<"col-sm-6" l><"col-sm-6" p>>rt<"bottom"<"dt-row"<"col-sm-6 deactivate-button"><"col-sm-6 pull-right" i>>><"clear">',
    responsive: true,
    "aaSorting": [],
    "columnDefs": [ {
      "targets": 'no-sort',
      "orderable": false,
    } ],
    "oLanguage": {
      "sEmptyTable": I18n.t('sEmptyTable'),
      "sInfo": I18n.t('sInfo'),
      "sInfoEmpty": I18n.t('sInfoEmpty'),
      "sInfoFiltered": I18n.t('sInfoFiltered'),
      "sInfoPostFix": I18n.t('sInfoPostFix'),
      "sInfoThousands": I18n.t('sInfoThousands'),
      "sLengthMenu": I18n.t('sLengthMenu'),
      "sLoadingRecords": I18n.t('sLoadingRecords'),
      "sProcessing": I18n.t('sProcessing'),
      "sSearch": I18n.t('sSearch'),
      "sZeroRecords": I18n.t('sZeroRecords'),
      "oPaginate": {
        "sFirst": I18n.t('oPaginate.sFirst'),
        "sLast": I18n.t('oPaginate.sLast'),
        "sNext": I18n.t('oPaginate.sNext'),
        "sPrevious": I18n.t('oPaginate.sPrevious')
      },
      "oAria": {
        "sSortAscending": I18n.t('oArias.sSortAscending'),
        "sSortDescending": I18n.t('oArias.sSortDescending')
      }
    }  
  });
  $("div.new-button").html($(".link-to-new").html());
  $("div.deactivate-button").html($("#deactivate_button").html());

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
  $(this).datepicker({"format": "MM dd, yyyy", "weekStart": 1, "forceParse":false, "autoclose":true, "defaultViewDate":"today", "orientation": "bottom"});
});