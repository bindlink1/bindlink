$(document).ready(
    $(function(){

$('#customdate').hide();
        if ($('#customdate').val().length > 0) {
            $('#customfieldvalue_value').hide();
            $('#customdate').show();
        }
        if ($('#customfieldvalue_value').val().length > 0)
        {


        }
        else
        {
            $('#customfieldvalue_value').attr("disabled","disabled");

        }



        $("#new_customfieldvalue").validate();
        $("#customdate").validate();
        $('#customfieldvalue_customfield_id').change(function(){customvaluetype()});
        $('#customdate').datepicker();
    }));



function customvaluetype(){

    var customfieldid = $('#customfieldvalue_customfield_id').val();

    $.ajax({
        type: "GET",
        dataType: "json",
        data: "customfield_id=" + customfieldid,
        url: "/customfields/fieldtype",
        success: function(data){

            if (data.type == 'Date')
            {
                $('#customfieldvalue_value').val('');
                $('#customfieldvalue_value').hide();
                $('#customdate').show();
            }
            else {
                $('#customfieldvalue_value').show();
                $('#customdate').hide();
                $('#customdate').val('');
                $('#customfieldvalue_value').removeAttr("disabled");
            }

        }

    });



}