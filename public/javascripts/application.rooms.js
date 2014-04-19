$(document).ready(function(){
  $('.datepicker').datepicker({ dateFormat: 'yy-mm-dd', numberOfMonths: [1, 2],showButtonPanel: true });
});

function check_rates(poi_id){
  var check_in = $("#check_in").val();
  var check_out = $("#check_out").val();
  var url = "/check_rates?id=" + poi_id + "&check_in=" + check_in + "&check_out=" + check_out;
  console.log(url);
  showLoading();

  $.ajax({
    type: 'POST',
    url: url,
    dataType: 'json',
    success: process
  });

}

function process(data){
  $("#ajax-loader").remove();
  $("#available_rooms").slideDown();

  var datatable = $("#rooms_list").dataTable();

  datatable.fnClearTable();

  for (var i=0; i < data.length; i++) {
    var array_columns = [];
    array_columns.push ( data[i].room_type,
                         data[i].currency,
                         data[i].rate,
                         data[i].provider,
                         data[i].valid_dates);
    datatable.fnAddData(array_columns);
  }

  datatable.fnSort( [[2, 'asc']]);

}

function showLoading(){
  var content = '<div class="entry-single" id="ajax-loader">';
  content = content + '<img src="/images/ajax-loader-small.gif">';
  content = content + " Please wait as we fetch rooms for each provider...";
  content = content + "</div>";

  $("#rooms_header").after(content);
  $("#available_rooms").slideUp();
}