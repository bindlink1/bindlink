$(document).ready(function() {
    $('#new_statement :checkbox').click(function() {

        var $row = $(this).parents('tr');

        if(this.checked){
            $(this).parents('tr').css("background-color","#d0fadf");
        }
        else
        {
            $(this).parents('tr').css("background-color", "");
        }

        var comm = Number($row.find('td:eq(4)').html().replace(/[^0-9\.]+/g,""));
        if ($row.find('td:eq(4)').html().indexOf(")") != -1){comm=comm*-1} ;
        addtotalcomm(comm,this.checked, '#comm_total' );

        var ncomm =  Number($row.find('td:eq(5)').html().replace(/[^0-9\.]+/g,"")) ;
        if ($row.find('td:eq(5)').html().indexOf(")") != -1){ncomm=ncomm*-1} ;
        addtotalcomm(ncomm,this.checked, '#noncomm_total' );

        var commish =  Number($row.find('td:eq(6)').html().replace(/[^0-9\.]+/g,"")) ;
        if ($row.find('td:eq(6)').html().indexOf(")") != -1){commish=commish*-1} ;
        addtotalcomm(commish,this.checked, '#commish_total' );

        var prem =  Number($row.find('td:eq(7)').html().replace(/[^0-9\.]+/g,"")) ;
        if ($row.find('td:eq(7)').html().indexOf(")") != -1){prem=prem*-1} ;
        addtotalcomm(prem,this.checked, '#premiumtotal_total' );

    });

});

function addtotalcomm (amount, posnev, field){

    var currtotal =  Number( $(field).html().replace(/[^0-9\.]+/g,""));
     if ($(field).html().indexOf(")") != -1){currtotal=currtotal*-1} ;

    if (isNaN(currtotal)){currtotal=0}
    if (posnev){
        currtotal = currtotal + amount;
    } else
    {
        currtotal = currtotal - amount;
    }
    $(field).html(currtotal).formatCurrency();
}

