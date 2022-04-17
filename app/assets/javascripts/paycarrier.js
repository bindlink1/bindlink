  $("#gobackpay").click(function(){resetpaycarrier()});

    function resetpaycarrier(){
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


 $('#cashtransaction_cash_amount').change(function() {  $(this).formatCurrency() });


  $(document).ready(
    $(function(){


        $("#new_cashtransaction").validate({
            rules: {
                "cashtransaction[cash_amount]": {  required: true,
                    greaterThanZero: true}


            }

        });

        jQuery.validator.addMethod("greaterThanZero", function(value, element) {
            var tempval = value.replace(/[^0-9\.\(\)]+/g,"");
            return this.optional(element) || (
                parseFloat(tempval).toFixed(2) > 0);
        }, "* Amount must be greater than zero");





    }));