$(".trbutton").live("click", function(e){

$(e.target).closest('td').html("<img width='25px' height='25px' src='/assets/ajax-loader.gif' alt='Check'>")

});

$(".deleteal").live("click", function(e){

    $(e.target).closest('tr').slideUp(300);

});