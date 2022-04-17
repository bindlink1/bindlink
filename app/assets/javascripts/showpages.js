
    $('img.lazy').lazyload({
        threshold: 600,


        skip_invisibles: false
    });




    $(".thumbnail").live("click", function(){

        goToByScroll($(this).attr("id"));
        highlightborder($(this).attr("id"));

    });


    function goToByScroll(id){

        // Scroll
        $('html,body').animate({
                scrollTop: $("#page_"+id).offset().top},
            'slow');



    }

    $("#zoomin").live("click", function(){

        zoomin();
    });
    $("#zoomout").live("click", function(){

        zoomout();
    });


    function zoomout(){

        var w = $("img.lazy").width();
        var h = $("img.lazy").height();

        $("img.lazy").width(w *.9);
        $("img.lazy").height(h *.9);
         $(".imgcontainer").css({width: (w *.9), height: (h *.9)});

    }

    function zoomin(){

        var w = $("img.lazy").width();
        var h = $("img.lazy").height();

        $("img.lazy").width(w *1.1);
        $("img.lazy").height(h * 1.1);
        $(".imgcontainer").css({width: (w * 1.1), height: (h * 1.1)});

    }

    function highlightborder(id){
    $("#"+id)
        .css({
            borderTopColor: 'blue',
            borderBottomColor: 'blue',
            borderRightColor: 'blue',
            borderLeftColor: 'blue',
            borderBottomWidth: 2
        })
       ;

        $("#"+id).siblings()
            .css({
                borderTopColor: '',
                borderBottomColor: '',
                borderRightColor: '',
                borderLeftColor: '',
                borderBottomWidth: 1
            })
        ;

        $("#"+id).addClass('selectedpage');
        $("#"+id).siblings.removeClass('selectedpage');

    };