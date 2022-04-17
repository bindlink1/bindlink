$(document).ready(
    $(function(){


        $('#headtable').outerWidth($('#scrolltable').outerWidth());

        var colCount = 0;
        $('#scrolltable tr:nth-child(1) td').each(function (index) {

        $('#headtable tr>td:nth-child('+ (index + 1) +')').outerWidth($(this).outerWidth()) ;

            if ($(this).attr('colspan')) {

                colCount += +$(this).attr('colspan');
            } else {
                colCount++;
            }
        });




    }));