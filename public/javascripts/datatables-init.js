$(document).ready(function(){
  $(".datatable tbody").click(function(event) {
    $(oTable.fnSettings().aoData).each(function (){
			$(this.nTr).removeClass('row_selected');
		});
		$(event.target.parentNode).addClass('row_selected');
	});

  oTable = $(".datatable").dataTable({
      "sScrollX": "100%",

      // The table cannot fit into the current element which will cause column misalignment. It is suggested that you increase the
      // sScrollXInner property to allow it to draw in a larger area, or simply remove that parameter to allow automatic calculation
      //"sScrollXInner": "100%",

    "bScrollCollapse": true,
    "bPaginate": false,
    "aaSorting": [] //disables initial sort
  });
});