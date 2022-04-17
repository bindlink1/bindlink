$(document).ready(function() {

  $("#policy_effective_date").datepicker();
  $("#policy_expiration_date").datepicker();
  $('#policy_policypremiumtransactions_attributes_0_invoices_attributes_0_due_on').datepicker();
  $("#complexfeerow").hide();
  $('#policy_carrier_id').change( carrierlobgnome );
  $('#policy_lineofbusiness_id').change( onLobChange );
  $('#policy_line_id').change(function(){});

  $('#policy_policypremiumtransactions_attributes_0_fees').change(function(){$(this).formatCurrency()});
  $('#policy_policypremiumtransactions_attributes_0_invoices_attributes_0_total_billed').change(function(){$(this).formatCurrency()});

  $("#new_policy").validate();

  $('#calcpolicy').on('click.mynamespace',function(){  feegnome();});

  $('#policy_policypremiumtransactions_attributes_0_base_premium').change(function(){

    feegnome();
    $('#policy_policypremiumtransactions_attributes_0_base_premium').formatCurrency()

  });

  $('#policy_policypremiumtransactions_attributes_0_fees').change(function(){
    feegnome();
    totalpremcalc();

  });
  $('#complexfeetotal').change(function(){

    feegnome();
    $('#complexfeetotal').formatCurrency();
    totalpremcalc();

  });



  $('#policy_effective_date').change(function() {
    expdategnome();
    checkeffdate();
    invoicedategnome();
    feecalculation();



  });

  $('#policy_expiration_date').change(function() {
    expdategnome();
  });

  $('#policy_policy_term').change(function() {
    expdategnome();
  });
  totalpremcalc();
  onLobChange();
});
//end
//}));


function carrierlobgnome(){
  var carrierid = $('#policy_carrier_id').val();

  $.ajax({
    type: "GET",
    dataType: "json",
    data: "carrier_id=" + carrierid,
    url: "/policies/carrierlobs",
    success: function(data){
      $('#policy_lineofbusiness_id').html("");
      $("<option value=''>Select One</option>").appendTo("#policy_lineofbusiness_id");
      $.each(data.lobs,function(index, lobs){
        $("<option value='" + lobs.id + "' tag='" + lobs.billing_type + "'>" + lobs.line_name + "</option>").appendTo("#policy_lineofbusiness_id");
      });
      $('#policy_lineofbusiness_id').removeAttr("disabled").effect('highlight',1000);
    }
  });
}


function onLobChange(){
  var billingType = $('#policy_lineofbusiness_id option:selected').attr('tag');
  if( billingType == "0" ) {
    $('#billingTypeRow').slideDown();
    $('#policy_payment_type_id').val( '' );
  }
  else {
    $('#billingTypeRow').slideUp();
    $('#policy_payment_type_id').val( billingType );
  }
}


function feegnome(){
  if($('.complexfee input').length == 0){
    feecalculation()
  }
  else{
    feerecalculation()
  }
  $('#policy_lineofbusiness_id').removeAttr("disabled");
}


function feerecalculation() {
  var state = $('#policy_state').val();
  var effective_date = $('#policy_effective_date').val();
  var lineofbusinessid = $('#policy_lineofbusiness_id').val();
  var basepremiumtemp =  $('#policy_policypremiumtransactions_attributes_0_base_premium').val().replace(/[^0-9\.]+/g,"") ;
  var basepremium  =  parseFloat(basepremiumtemp).toFixed(2) ;

  $.ajax({
    type: "GET",
    dataType: "json",
    data: {state:state, lob:lineofbusinessid, basepremium:basepremium, effective_date:effective_date},
    url: "/policies/feecalcs",
    success: function(data){
      var feetotal = 0;
      var feecount = 0 ;

      $.each(data.fees,function(index, fees){
        if(fees[0].fee_remit_type == 'Revenue'){
          basepremium = Number(basepremium) + (1* $("#fees_"+fees[0].id ).val().replace(/[^0-9\.]+/g,"")) ;
        }
      } );

      $.each(data.fees,function(index, fees){
        if(fees[0].fee_remit_type != 'Revenue'){
          if(fees[0].fee_type == 'Percent'){
            $("#fees_"+fees[0].id ).val(roundfix(basepremium * fees[0].fee_value));
            feetotal = feetotal + ( roundfix(basepremium * fees[0].fee_value));
          }
          else {
            $("#fees_"+fees[0].id ).val(fees[0].fee_value);
            feetotal = feetotal + (1* fees[0].fee_value);
          }
        }
        else {
          feetotal = feetotal + (1* $("#fees_"+fees[0].id ).val().replace(/[^0-9\.]+/g,""));
        }

        feecount = feecount +1
      });

      $('.complexfee input').formatCurrency();
      $(".complexfee input").live('change', function(){
        $('.complexfee input').formatCurrency();
        recalculatefees();
      });
      if (feecount > 0){
        $("#complexfeerow").slideDown(300);
        $("#complexfeetotal").val(feetotal).formatCurrency();
        $('#simplefeerow').hide();
      }
      totalpremcalc();
    }
  });
}


function feecalculation() {
  var state = $('#policy_state').val();
  var effective_date = $('#policy_effective_date').val();
  var lineofbusinessid = $('#policy_lineofbusiness_id').val();
  var basepremiumtemp =  $('#policy_policypremiumtransactions_attributes_0_base_premium').val().replace(/[^0-9\.]+/g,"") ;
  var basepremium  =  parseFloat(basepremiumtemp).toFixed(2) ;

  $.ajax({
    type: "GET",
    dataType: "json",
    data: {state:state, lob:lineofbusinessid, basepremium:basepremium, effective_date:effective_date},
    url: "/policies/feecalcs",
    success: function(data){
      $(".complexrow").remove();

      $("#feerow").html("");
      $(".complexrow").html("");
      var feetotal = 0;
      var feecount = 0 ;

      $.each(data.fees,function(index, fees){
        if(fees[0].fee_remit_type == 'Revenue'){
          basepremium = Number(basepremium) + (1*fees[0].fee_value)
        }
      } );

      $.each(data.fees,function(index, fees){
        if(fees[0].fee_type == 'Percent'){
          $("#feerow").after("<tr class='complexrow'><td>&nbsp;&nbsp; + " + fees[0].fee_name + "</td><td> <div class='complexfee'> <input id='fees_"+fees[0].id +"' class='BLselect span2' type='text' size='30' name='policy[policypremiumtransactions_attributes][0][feetransactions_attributes]["+ feecount +"][fee_amount]' autocomplete='off' value="+ roundfix(basepremium * fees[0].fee_value) +"></div><input type='hidden' id='feesid_"+fees[0].id +"' class='BLselect span2' type='text' size='30' name='policy[policypremiumtransactions_attributes][0][feetransactions_attributes]["+ feecount +"][fee_id]' autocomplete='off' value="+ fees[0].id +"></input> <!--input type='hidden' id='feevalue_"+fees[0].id +"' class='BLselect span2' type='text' size='30' name='policy[policypremiumtransactions_attributes][0][feetransactions_attributes]["+ feecount +"][fee_value]' autocomplete='off' value="+ fees[0].fee_value +"></input><input type='hidden' id='feetype_"+fees[0].id +"' class='BLselect span2' type='text' size='30' name='policy[policypremiumtransactions_attributes][0][feetransactions_attributes]["+ feecount +"][fee_type]' autocomplete='off' value="+ fees[0].fee_type +"></input--></td></tr>");

          feetotal = feetotal + roundfix(basepremium * fees[0].fee_value);
        }
        else {
          $("#feerow").after("<tr class='complexrow'><td>&nbsp;&nbsp; + " + fees[0].fee_name + "</td><td> <div class='complexfee'><input id='fees_"+fees[0].id +"' class='BLselect span2' type='text' size='30' name='policy[policypremiumtransactions_attributes][0][feetransactions_attributes][" + feecount + "][fee_amount]' autocomplete='off' value="+  fees[0].fee_value +"></div><input type='hidden' id='feesid_"+fees[0].id +"' class='BLselect span2' type='text' size='30' name='policy[policypremiumtransactions_attributes][0][feetransactions_attributes]["+ feecount +"][fee_id]' autocomplete='off' value="+ fees[0].id +"></input> <!--input type='hidden' id='feevalue_"+fees[0].id +"' class='BLselect span2' type='text' size='30' name='policy[policypremiumtransactions_attributes][0][feetransactions_attributes]["+ feecount +"][fee_value]' autocomplete='off' value="+ fees[0].fee_value +"></input><input type='hidden' id='feetype_"+fees[0].id +"' class='BLselect span2' type='text' size='30' name='policy[policypremiumtransactions_attributes][0][feetransactions_attributes]["+ feecount +"][fee_type]' autocomplete='off' value="+ fees[0].fee_type +"></input--></td></tr>");

          feetotal = feetotal + (1* fees[0].fee_value);
        }

        feecount = feecount +1
      });

      $('.complexfee input').formatCurrency();
      $(".complexfee input").live('change', function(){
        $('.complexfee input').formatCurrency();
        feegnome();
      });
      if (feecount > 0){
        $("#complexfeerow").slideDown(300);
        $("#complexfeetotal").val(feetotal).formatCurrency();
        $('#simplefeerow').hide();
      }
      totalpremcalc();
    }
  });
}



function recalculatefees(){

  var feetotal = 0;
  $('.complexfee input').each(function (i) {
    var tempval = $(this).val().replace(/[^0-9\.]+/g,"") ;
    var feeval   =  parseFloat(tempval).toFixed(2) ;
    feetotal = Number(feetotal) + Number(feeval);
  });
  $("#complexfeetotal").val(feetotal).formatCurrency();
  totalpremcalc();
}


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

function checkeffdate(){
  var effdate = $('#policy_effective_date').val();
  var evaldate = new Date(effdate);
  //had to add sethours to 24 because if not the evaluation below was taking time of day into account

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


  var pterm  = 0;

  var ptermselect = $('#policy_policy_term').val();

  if (ptermselect == '12 Month') {expdateforce(12)};
  if (ptermselect == '6 Month') {expdateforce(6)};



};

function expdateforce(pterm){
  var expdate = $('#policy_effective_date').val();
  var myDate = new Date(expdate);
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
}

function totalpremcalc(){



  if ($("#complexfeetotal").val() != null){
    var complextemp =  $('#complexfeetotal').val().replace(/[^0-9\.]+/g,"") ;
    var complex = parseFloat(complextemp).toFixed(2);
  }


  //removing mask to add values

  if ($('#policy_policypremiumtransactions_attributes_0_fees').val() != null){
    var feetemp = $('#policy_policypremiumtransactions_attributes_0_fees').val().replace(/[^0-9\.]+/g,"");
  }

  var fees = parseFloat(feetemp).toFixed(2);
  if ($('#policy_policypremiumtransactions_attributes_0_base_premium').val() != null){
    var basepremiumtemp =  $('#policy_policypremiumtransactions_attributes_0_base_premium').val().replace(/[^0-9\.]+/g,"") ;
  }
  var basepremium  =  parseFloat(basepremiumtemp).toFixed(2) ;

  if (isNaN(fees)){fees=0}
  if (isNaN(basepremium)){basepremium=0}
  if (isNaN(complex)){complex=0}


  $('#policy_policypremiumtransactions_attributes_0_total_premium').val(Number(basepremium) + Number(fees) + Number(complex));

  $('#policy_policypremiumtransactions_attributes_0_total_premium').formatCurrency();
  $('#policy_policypremiumtransactions_attributes_0_base_premium').formatCurrency();
}
