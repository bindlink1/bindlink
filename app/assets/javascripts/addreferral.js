$(document).ready(function(){
    $("#newreferer").hide();

});

$("#addreferralsource").click(function(){
    $("#referral_client_id").val('');
    $("#referral_referer_id").val('');
    $("#existingreferer").slideUp(300);
    $("#newreferer").slideDown(300);

});


$('#refcancel').click(function(){$('#clientinfowork').slideUp(300).html('');$("#clientinfo").slideDown(300); });
$('#refferalsourceback').click(function(){

    $("#existingreferer").slideDown(300);
    $("#newreferer").slideUp(300);
    $("#referral_referer_attributes_referer_name").val('');
});

