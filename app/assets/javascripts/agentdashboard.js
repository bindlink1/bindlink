

$(function () {
    $("#button1").popover(
        {
            offset: 5,
            placement: 'right'
        }
    );
});

$('#myTab a').click(function (e) {
    e.preventDefault();
    $(this).tab('view');

});

$(function () {
    $('#myTab a:first').tab('view');

});



$("#taskheaderwork").hide();




