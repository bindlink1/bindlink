// Listen for click on toggle checkbox



$("#select-all").live("click", function(e){

    if(this.checked) {
        // Iterate each checkbox
        $(':checkbox').each(function() {
            this.checked = true;
        })

    }
    else {  $(":checkbox").each(function() { this.checked = false; })};
});