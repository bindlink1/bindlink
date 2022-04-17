$(document).ready(
    $(function(){

        $('#quote_lineofbusiness_id').attr("disabled","disabled");
        $('#quote_carrier_id').change(function(){carrierlobgnome()});





function carrierlobgnome(){

    var carrierid = $('#quote_carrier_id').val();

    $.ajax({
        type: "GET",
        dataType: "json",
        data: "carrier_id=" + carrierid,
        url: "/policies/carrierlobs",
        success: function(data){
            $('#quote_lineofbusiness_id').html("");
            $("<option value=''>Select One</option>").appendTo("#submission_quote_lineofbusiness_id");
            $.each(data.lobs,function(index, lobs){

                $("<option value='" + lobs.id + "'>" + lobs.line_name + "</option>").appendTo("#quote_lineofbusiness_id");});
    $('#quote_lineofbusiness_id').removeAttr("disabled");

    $("#quote_lineofbusiness_id").effect('highlight',1000);

        }

    });



}

    }) );

