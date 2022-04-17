$(document).ready(
    $(function(){
        $("#corpname").hide();
        $("#firstname").hide();
        $("#lastname").hide();
        $("#client_client_type").change(function(){clientname(this.value)});
        $("#submission_client_attributes_client_type").change(function(){clientname(this.value)});
    }) );


function clientname (cval){

            if (cval == "Individual"){

                $("#corpname").hide();
                $("#client_corporate_name").val("");
                $("#firstname").slideDown(100);
                $("#lastname").slideDown(100);

            }
            else
            {
                $("#firstname").hide();
                $("#lastname").hide();
                $("#client_first_name").val("");
                $("#client_last_name").val("");
                $("#corpname").slideDown(100);

            }

}


