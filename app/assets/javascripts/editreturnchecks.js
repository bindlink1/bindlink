$('#confirmprint').hide();
$("#printcheck").click(function(){

    $('#printchecks').fadeOut(300);
    $('#confirmprint').fadeIn(300);


});
$("#notprinted").click(function(){

    $('#printchecks').fadeIn(300);
    $('#confirmprint').fadeOut(300);


});

