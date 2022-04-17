// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//
//= require jquery
//= require jquery_ujs

//= require jquery-ui
//= require dataTables/jquery.dataTables
//= require date
//= require bootstrap

$(function(){
    $("#invoices").dataTable(

        {

            "sPaginationType" : "full_numbers",
            "bJQueryUI" : true


        }

    );
});

$(function(){
    $("#policies").dataTable(

        {

            "sPaginationType" : "full_numbers",
            "bJQueryUI" : true


        }

    );
});





$(function(){
    $("#cashtransactions").dataTable(

        {


            "bJQueryUI" : true,
            "bFilter": false,
            "bLengthChange": false,
            "bInfo": false,
            "bPaginate": false


        }

    );
});


$(function(){
    $("#invoicedetails").dataTable(

        {


            "bJQueryUI" : true,
            "bFilter": false,
            "bLengthChange": false,
            "bInfo": false,
            "bPaginate": false,
            "bSort": false,
            "sDom": ''

        }

    );
});

$(function(){
    $(".topdetails").dataTable(

        {


            "bJQueryUI" : true,
            "bFilter": false,
            "bLengthChange": false,
            "bInfo": false,
            "bPaginate": false,
            "bSort": false,
            "sDom": ''

        }

    );
});



$(function(){
    $("#agency_approved_on").datepicker();
}) ;




$(function() {
    $('#dialog').dialog();
});




function editeffdate(){



    $("#dialogquestion").modal(backdrop="true");
    $("#dialogquestion").html('<div class="modal-header">Are you sure?</div><div class="modal-body">Policy effective date is in the past.</div><div class="modal-footer"><button id="yestoenter">Yes </button> <button id="notoenter">No </button> </div>');

    $("#yestoenter").click(function(){

        $("#dialogquestion").modal("close");
    });



};

/*

 function checkeffdate(){
 var effdate = $('#policy_effective_date').val();
 var evaldate = new Date(effdate);
 //had to add sethours to 24 because if not the evaluation below was taking time of day into account and

 evaldate.setHours(24);
 var todaydate = new Date();

 if ( todaydate > evaldate ) {


 $("#dialogquestion").dialog();
 $("#dialogquestion").html('<b>Are you sure you want an effective date in the past?</b> </br> <button id="yestoenter">Yes </button> <button id="notoenter">No </button> ');

 $("#yestoenter").click(function(){

 $("#dialogquestion").dialog("close");
 });

 $("#notoenter").click(function(){
 $("#policy_effective_date").val(null);
 $("#policy_expiration_date").val(null);
 $("#dialogquestion").dialog("close");
 });





 };

 }

 function expdategnome() {

 var expdate = $('#policy_effective_date').val();
 var myDate = new Date(expdate);
 var pterm  = 0;

 var ptermselect = $('#policy_policy_term').val();

 if (ptermselect == '12 Month') {pterm = 12};
 if (ptermselect == '6 Month') {pterm = 6};
 if (ptermselect == '') {pterm = 12; $('#policy_policy_term').val('12 Month'); $('#policy_policy_term').effect('highlight',1000); };

 myDate.setDate(myDate.getDate());

 myDate.setMonth(myDate.getMonth()+pterm);


 var exp_date = myDate.getDate();
 var exp_month = myDate.getMonth()+1;
 var exp_year = myDate.getFullYear();

 if(exp_date < 10){exp_date = "0"+exp_date }
 if(exp_month < 10){exp_month = "0"+exp_month }

 if (expdate != '')  {
 $('#policy_expiration_date').val( exp_month +"/"+ exp_date +"/"+ exp_year );
 $('#policy_expiration_date').effect('highlight',1000);
 }

 };



 function invoicedategnome() {

 var effdate = $('#policy_effective_date').val();
 $.ajax({

 type: "GET",
 dataType: "text",
 data: "effectivedate=" + effdate,
 url: "/policies/invoicedue",
 success: function(data){


 $('#policy_policypremiumtransactions_attributes_0_invoices_attributes_0_due_on').val(data);

 $('#policy_policypremiumtransactions_attributes_0_invoices_attributes_0_due_on').effect('highlight',1000);
 }


 });


 };
 */





