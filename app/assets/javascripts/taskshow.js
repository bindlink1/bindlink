$('.taskback').click(function(){
    $('.controlright:visible').find('.taskwork').slideUp(300);
    $('.controlright:visible').find('.taskheaderwork').slideUp(300);
    $('.controlright:visible').find('.tasktablewrapper').slideDown(300);
    $('.controlright:visible').find('.taskheader').slideDown(300);
});
