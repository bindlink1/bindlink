$('#cashtransaction_cash_amount').change(function() {  $(this).formatCurrency() });




$(document).ready(
    $(function(){

        $("#cashtransaction_transaction_effective_date").datepicker();
        $("#new_cashtransaction").validate();}));