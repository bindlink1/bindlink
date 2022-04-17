
$(document).ready(
    $(function(){

        $('.add_fields').click(function (e) {

            time = new Date().getTime();
            regexp = new RegExp($(this).data('id'), 'g') ;


            $(this).prev().append($(this).data('fields').replace(regexp, time)).hide().slideDown(300);
            e.preventDefault();
            $('html, body').animate({
                scrollTop:  $(this).prev().offset().top
            }, 2000);

        });


        $(".remove_vehicle").live("click", function(){
            var r=confirm("Are you sure you want to remove this vehicle?");
            if (r==true)
            {
                $(this).closest('fieldset').slideUp(300).html('');
            }
        });

        $(".remove_driver").live("click", function(){
            var r=confirm("Are you sure you want to remove this driver?");
            if (r==true)
            {
                $(this).closest('fieldset').slideUp(300).html('');
            }
        });

        $(".remove_location").live("click", function(){
            var r=confirm("Are you sure you want to remove this location?");
            if (r==true)
            {
                $(this).closest('fieldset').slideUp(300).html('');
            }
        });

    }));





