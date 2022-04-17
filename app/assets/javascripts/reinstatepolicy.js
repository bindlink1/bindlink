   $("#gobackreinstatement").click(function(){abortreinstate()});

   function abortreinstate(){
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