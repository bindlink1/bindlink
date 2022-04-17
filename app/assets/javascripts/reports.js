$(document).ready(function() {

    $("#startdate").datepicker();
    $("#enddate").datepicker();
    $("#startdatecomm").datepicker();
    $("#enddatecomm").datepicker();
    $("#startdatelist").datepicker();
    $("#enddatelist").datepicker();
    $("#startdatelistacc").datepicker();
    $("#enddatelistacc").datepicker();
    $("#startdatelistsl").datepicker();
    $("#enddatelistsl").datepicker();
    $("#startdatelistsla").datepicker();
    $("#enddatelistsla").datepicker();
    $("#startdateexp").datepicker();
    $("#enddateexp").datepicker();
    $("#startdaterenewal").datepicker();
    $("#enddaterenewal").datepicker();
    $("#startdatereturnrpt").datepicker();
    $("#enddatereturnrpt").datepicker();

    $("#cashrpt").hide();
    $("#policytransactionrpt").hide();
    $("#agingrpt").hide();
    $("#feesrpt").hide();
    $("#surpluslinesrpt").hide();
    $("#surpluslinesrptauto").hide();
    $("#commissionrpt").hide();
    $("#accountrpt").hide();
    $("#expirationrpt").hide();
    $("#renewalrpt").hide();
    $("#returnrpt").hide();
    $("#producerrpt").hide();

    $("#rptselect").change(function(){
        var name = $(this).val();
        switch( name ) {
            case 'policytrans' : name = 'policytransactionrpt'; break;
            case 'agedrec' : name = 'agingrpt'; break;
            case 'surplus' : name = 'surpluslinesrpt'; break;
            case 'surplusauto' : name = 'surpluslinesrptauto'; break;
            case 'fees' : name = 'nothing'; break;
            default: name += 'rpt';
        }

        if( $('#surpluslinesrpt').parent().find('.wellwhite:visible').length > 0 )
            $('#surpluslinesrpt').parent().find('.wellwhite:visible').fadeOut(300, function(){$( '#' + name ).slideDown(300);})
        else
            $( '#' + name ).slideDown(300);
    });
});
