
function uploadstatus(status){

    if (status == 'start'){
        $("#uploadstatus").addClass("alert");
        $("#uploadstatus").html('uploading your document');
    }
    if (status == 'complete'){
        $("#uploadstatus").addClass("alert-success");
        $("#uploadstatus").html('upload status: ' + status)
    }




}


$(document).ready(
    $(function(){

        $("#new_note").validate();
        $("#uploadbutton").click(function(){uploadstatus('start');});
        $('#policyactions').hide();
        $('#noteform').hide();
        $('#renewcontainer').hide();
        $('#hiderenewals').hide();
        $('#doclistview').hide();
        $("#newnotebtn").click(function(){$('#noteform').slideDown(300);});
        $("#notecancel").click(function(){$('#noteform').slideUp(300); $("#note_notetext").val("");});
        $("#viewrenewals").click(function(){$('#renewcontainer').slideDown(300); $("#viewrenewals").hide(); $("#hiderenewals").show();});
        $("#hiderenewals").click(function(){$('#renewcontainer').slideUp(300); $("#hiderenewals").hide(); $("#viewrenewals").show();});
        $("#listviewdocs").click(function(){$('#docgridview').fadeOut(300);$('#doclistview').fadeIn(300);});
        $("#gridviewdocs").click(function(){$('#doclistview').fadeOut(300);$('#docgridview').fadeIn(300);});






    }) );



function updatepolicy(policy_id , transactiontype){

    $.ajax({

        type: "GET",
        dataType: "script",
        data: {transtype:transactiontype, policy_id:policy_id},
        url: "/policies/updateaftertransaction"



    });

};


//makes ajax call to see if there is a balance on the policy
function openinvoicegnome() {
    var totalreturn =  $('#policypremiumtransaction_total_premium').val().replace(/[^0-9\.\(\)]+/g,"");
    var basepremium =  $('#policypremiumtransaction_base_premium').val();

    $.ajax({

        type: "GET",
        dataType: 'json',
        data: "totalreturn=" + totalreturn,
        url: "/policies/cancbalance",
        success: function(data){

            var endingreturn = totalreturn  - data.balanceamount
            var returnpremiumtext = "";
            if (endingreturn < 0){

                var balancestilldue = "Note: Even after applying the return premium, there is still a balance on this policy." ;
                endingreturn = endingreturn * -1

            }
            else{
                var balancestilldue = "";
                var topolicyholder = endingreturn;
                endingreturn = 0;

                var returnpremiumtext = '<tr><td><b>Return to Policyholder:</b></td><td></td><td style=" text-align: right;"><b>'+ addCommas(parseFloat(topolicyholder).toFixed(2)) +'</b></td></tr>'
            }

            if (data.balance =='balance' && totalreturn != 0 ){

                $('#my-modal').html('<div class="modal-header"><img src="/assets/bindlinklogofunctional.png"></div><div class="modal-body"><div class="alert"><p>This policy has an invoice with a balance due to your agency. <ul><h4 class="alert-heading">Would you like to apply this return premium towards that invoice?</h4><ul></ul></p>'+ balancestilldue + '</div> <table><tr><th colspan="3" style="border-bottom: 1px solid black; ">Here is what the math looks like</th></tr><tr style="margin-top: 10px;"><td>Invoice Balance:</td><td></td><td style=" text-align: right;">'+ addCommas(parseFloat(data.balanceamount).toFixed(2)) +'</td></tr><tr><td>Return Premium:</td><td>-</td><td style="border-bottom: 1px solid black; text-align: right;">'+ totalreturn +'</td></tr><tr><td>New Invoice Balance:</td><td></td><td style=" text-align: right;">'+ addCommas(parseFloat(endingreturn).toFixed(2)) +'</td></tr>'+ returnpremiumtext +'</table></div><div class="modal-footer"> <a href="#" class="btn btn-primary" id="yesapply">Yes, apply to invoice</a><a href="#" class="btn" id="noapply">No</a></div>'
                );

                $("#yesapply").click(function(){
                    applyreturntoinvoice(totalreturn, basepremium);
                });

                $("#noapply").click(function(){
                    $('#my-modal').modal('hide');
                    updatepolicy();
                });

                $('#my-modal').addClass('modal');
                //this should fix an old IE problem
                $('.modal').appendTo($('body'));
                $('#my-modal').modal({
                    show : true,
                    keyboard : true,
                    backdrop : true
                });

            }
            else{updatepolicy()}

        }


    });

}


function returnamountgnome() {

    var totalreturn = $('#policypremiumtransaction_total_premium').val();
    $.ajax({

        type: "GET",
        dataType: "text",
        data: "totalreturn=" + totalreturn,
        url: "/policies/returnamountgnome",
        success: function(data){


            if (data =='over'){
                $('#my-modal').html('<div class="modal-header"><button class="close" data-dismiss="modal">×</button><h3>Alert</h3></div><div class="modal-body"><p>The Amount you have entered is greater than the total written premium for this policy.</p></div><div class="modal-footer"><a href="#" class="btn" id="returndismiss" data-dismiss="modal">Ok</a></div>');

                $('#my-modal').addClass('modal');

                $('#my-modal').modal({
                    show : true,
                    keyboard : true,
                    backdrop : true
                });

            }


        }


    });


}

function applyreturntoinvoice(returnpremium, basepremium){
    $.ajax({

        type: "POST",
        dataType: 'json',
        data: {returnpremium:returnpremium, basepremium:basepremium},
        url: "/policies/cancellationreturntoinvoice",
        success: function() { $('#my-modal').modal('hide'); updatepolicy();  }
    });
}

function feecalc(){
    var feetotal = 0;
    var basepremiumtemp =  $('#policypremiumtransaction_base_premium').val().replace(/[^0-9\.]+/g,"") ;






    var basepremium  =  parseFloat(basepremiumtemp).toFixed(2) ;
    var feeval = new Array();
    var feetype = new Array();
    var remittype = new Array();


    $('.blvalue').each(function(index, domEle){


        feeval[index] = domEle.value;

    });


    $('.blremittype').each(function(index, domEle){
        remittype[index] = domEle.value;

    });

    $('.blinput').each(function(index, domEle){
        //if this fee is a revenue fee it needs to get added to the base premium for purposes of forward fee calculation
        if (remittype[index] == 'Revenue'){
            var temprevamt
            //looks to see if revenue fee has been overwritten, if so doesnt force default

            if ($(this).val().length > 0){

                temprevamt =  $(this).val().replace(/[^0-9\.]+/g,"");
            }else{
                domEle.value = feeval[index];
                temprevamt = feeval[index];
            };


            basepremium = Number(basepremium) + Number(temprevamt) ;

        }

    });



    $('.bltype').each(function(index, domEle){
        feetype[index] = domEle.value;
    });

    $('.blinput').each(function(index, domEle){

        if (remittype[index] == 'Revenue' && $(this).val().length > 0){
            domEle.value = $(this).val().replace(/[^0-9\.]+/g,"")
            feetotal = feetotal +  $(this).val().replace(/[^0-9\.]+/g,"") * 1;

        }
        else {
            if (feetype[index] == 'Flat'){



                domEle.value = feeval[index];

                feetotal = feetotal + feeval[index] * 1;
            }
            else{

                domEle.value = roundfix(feeval[index]*basepremium);
                feetotal = feetotal + roundfix(feeval[index]*basepremium);
            }

        }


    });

    $('#policypremiumtransaction_complexfees').val(feetotal).formatCurrency();
    $('.complexfee input').formatCurrency();

}

function totalpremcalc(){

    if ($("#policypremiumtransaction_complexfees").val() != null){

        var complextemp =  $('#policypremiumtransaction_complexfees').val().replace(/[^0-9\.]+/g,"") ;
        var complex = parseFloat(complextemp).toFixed(2);
    }


    //removing mask to add values

    var feetemp = 0;

    if ($('#policypremiumtransaction_fees').val() == undefined){feetemp=0}
    else{ feetemp = $('#policypremiumtransaction_fees').val().replace(/[^0-9\.]+/g,"")}


    var fees = parseFloat(feetemp).toFixed(2);

    var basepremiumtemp =  $('#policypremiumtransaction_base_premium').val().replace(/[^0-9\.]+/g,"") ;
    var basepremium  =  parseFloat(basepremiumtemp).toFixed(2) ;

    if (isNaN(fees)){fees=0}
    if (isNaN(basepremium)){basepremium=0}
    if (isNaN(complex)){complex=0}

    $('#policypremiumtransaction_total_premium').val(Number(basepremium) + Number(fees) + Number(complex));

    $('#policypremiumtransaction_total_premium').formatCurrency();
};

$('#policy_policypremiumtransactions_attributes_0_base_premium').change(function(){

    feegnome();
    $(this).formatCurrency()

});

$('body')
    .on('change', '#template_name', function(event) {
        var oldVal = $('#email_body').val();
        $('#email_body').val(oldVal + event.target.value);
    });