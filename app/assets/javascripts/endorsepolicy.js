$("#gobackendorse").click(function(){abortendorsement()});


$("#endorsetype").change(function(){


    if ($("#endorsetype").val() == "Return"){

        $("#recmoney").slideDown(300);

    }
    else{
        $("#recmoney").hide();

    }



});

function abortendorsement(){
    $('#policyactions').slideUp(300);
    $('#policyactions').html("");
    $('#policyfields').slideDown(300);
    $('#policytransinv').slideDown(300);
    $('#transactiontable').slideDown(300);
    $('#invoicetable').slideDown(300);
    $('#editpolbutton').removeAttr("disabled");
    $('#cancelpolbutton').removeAttr("disabled");
    $('#endorsepolbutton').removeAttr("disabled");

} ;





function feechangecalc(){

    var feetemp =  $('#policypremiumtransaction_fees').val().replace(/[^0-9\.\(\)]+/g,"");
    var fees =  parseFloat(feetemp).toFixed(2);
    var basepremiumtemp =  $('#policypremiumtransaction_base_premium').val().replace(/[^0-9\.\(\)]+/g,"");
    var basepremium =   parseFloat(basepremiumtemp).toFixed(2);
    if (isNaN(basepremium)){basepremium=0}
    $('#policypremiumtransaction_total_premium').val(Number(basepremium) +  Number(fees));
    $('#policypremiumtransaction_total_premium').effect('highlight',1000);
    $('#policypremiumtransaction_total_premium').formatCurrency();
}



$('#policypremiumtransaction_base_premium').change(function() {  $(this).formatCurrency();feecalc() ; totalpremcalc()  });
$('#policypremiumtransaction_taxes').change(function() { $(this).formatCurrency();  totalpremcalc()  });
$('#policypremiumtransaction_fees').change(function() { $(this).formatCurrency();  feechangecalc()  });
$('#policypremiumtransaction_complexfees').change(function() { $(this).formatCurrency();  feechangecalc()  });
$('.complexfee input').change(function() { $(this).formatCurrency(); recalculatefees()});
$(document).ready(
    $(function(){

        $("#recmoney").hide();

        $("#new_policypremiumtransaction").validate({
            rules: {
                "policypremiumtransaction[base_premium]": {  required: true,
                    greaterThanZero: true},
                "policypremiumtransaction[taxes]": {greaterThanZero: true},
                "policypremiumtransaction[fees]": { greaterThanEqualZero: true},
                "policypremiumtransaction[total_premium]": { greaterThanZero: true}

            }

        });

        jQuery.validator.addMethod("greaterThanZero", function(value, element) {
            var tempval = value.replace(/[^0-9\.\(\)]+/g,"");
            return this.optional(element) || (
                parseFloat(tempval).toFixed(2) > 0);
        }, "* Amount must be greater than zero");

        jQuery.validator.addMethod("greaterThanEqualZero", function(value, element) {
            var tempval = value.replace(/[^0-9\.\(\)]+/g,"");
            return this.optional(element) || (parseFloat(tempval).toFixed(2)>= 0);
        }, "* Amount must not be negative");



    }));


function recalculatefees(){

    var feetotal = 0;
    $('.complexfee input').each(function (i) {
        var tempval = $(this).val().replace(/[^0-9\.]+/g,"") ;
        var feeval   =  parseFloat(tempval).toFixed(2) ;
        if (isNaN( Number(feeval))){feeval=0};
        feetotal = Number(feetotal) + Number(feeval);

    });
    $("#policypremiumtransaction_complexfees").val(feetotal).formatCurrency();
    totalpremcalc();
}