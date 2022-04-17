$(document).ready(
    $(function(){

         $("#new_submission").validate();
         $('#submission_quote_carrier_id').change(function(){carrierlobgnome()});
            $('#submission_quote_lineofbusiness_id').attr("disabled","disabled");

    }) );


function carrierlobgnome(){

    var carrierid = $('#submission_quote_carrier_id').val();

    $.ajax({
        type: "GET",
        dataType: "json",
        data: "carrier_id=" + carrierid,
        url: "/policies/carrierlobs",
        success: function(data){
            $('#submission_quote_lineofbusiness_id').html("");
            $("<option value=''>Select One</option>").appendTo("#submission_quote_lineofbusiness_id");
            $.each(data.lobs,function(index, lobs){

                $("<option value='" + lobs.id + "'>" + lobs.line_name + "</option>").appendTo("#submission_quote_lineofbusiness_id");});


        }

    });
    $('#submission_quote_lineofbusiness_id').removeAttr("disabled");

    $("#submission_quote_lineofbusiness_id").effect('highlight',1000);


}


                 $("#gastep1").addClass("inactivestep");
$("#gastep2").removeClass("inactivestep");
$("#gastep2").addClass("activestep");
