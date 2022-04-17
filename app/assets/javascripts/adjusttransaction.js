$(document).ready(
    $(function(){

        $('#policypremiumtransaction_base_premium').formatCurrency();
        $('#policypremiumtransaction_fees').formatCurrency();

        feecalc() ;
        totalpremcalc();





    }));

$('#policypremiumtransaction_base_premium').change(function(){
    feecalc() ;
    totalpremcalc();
    $('#policypremiumtransaction_base_premium').formatCurrency();
        $('#policypremiumtransaction_fees').formatCurrency();



});


$('#policypremiumtransaction_fees').change(function(){

    totalpremcalc();
    $('#policypremiumtransaction_base_premium').formatCurrency();
        $('#policypremiumtransaction_fees').formatCurrency();



});


$(".blinput").change(function(){
  feecalc() ;
    totalpremcalc();
});







