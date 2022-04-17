$("#taskheaderwork").hide();

$(document).ready(
    $(function(){

        $(".submitcheck").live("click", function() {
            $(this).parents('form:first').submit();
        });


        if  ($('.controlright:visible').find('tasktablewrapper').is(":hidden")) {
            $('.controlright:visible').find('.tasktablewrapper').slideDown(300);
            $('.controlright:visible').find('.taskheader').slideDown(300);
            $('.controlright:visible').find('.taskheaderwork').slideUp(300);
            $('.controlright:visible').find('.taskwork').slideDown(300).html('');
        } ;


        $('.tasklink').click(function(){
            $('.controlright:visible').find('.taskwork').slideUp(300);
            $('.controlright:visible').find('.taskheaderwork').slideUp(300);
            $('.controlright:visible').find('.tasktablewrapper').slideDown(300);
            $('.controlright:visible').find('.taskheader').slideDown(300);
            $table = $(this).closest('tr').find('.tasktable');
            if ( $table.length == 0 )
                $table = $("#tasktable");
            $table.html("<tr><td style='text-align:center; height: 200px;'><img src='/assets/loader_bar.gif'></td></tr>");
            $(this).parent("li").addClass("active");
            $(this).parent("li").siblings().removeClass("active");
        });

    }));

