$("#searchdropdown li a").live("click", function(){
    var searchtype

    if (this.id =="search_policies"){
        searchtype = "Policies"
    }
    if (this.id =="search_clients"){
        searchtype = "Clients"
    }
    if (this.id =="search_prospects"){
        searchtype = "Prospects"
    }
    if (this.id =="search_phoneemail"){
        searchtype = "Phone/e-Mails"
    }
    if (this.id =="search_address"){
        searchtype = "Addresses"
    }
    if (this.id =="search_anything"){
        searchtype = "Anything"
    }
    if (this.id =="search_namedinsured"){
        searchtype = "Named Insureds"
    }
    if (this.id =="search_producingagency"){
        searchtype = "Producing Agencies"
    }
    if (this.id =="search_agencycode"){
        searchtype = "Agency Code"
    }

    $("#searchtypetxt").html(searchtype + '  <span class="caret" style="text-align: right;"></span>');
    $("#searchtypebtn").width($("#searchtypetxt").width());
    $("#searchtype").val(searchtype);
}) ;



$("#unisearchbtn").live("click", function(){
    $("#myModal").remove();
    $("#wrapper").append("<div class='modal wellwhiteblock' id='myModal' style='overflow: hidden;'><div class='wellwhitemenu'><button type='button' class='close' data_dismiss='modal' aria_hidden='true' id ='closeit'>×</button><h3>Searching</h3></div><div class='modal_body modalscroll' id='searchmodal'><div style='text-align: center'> <img src='/assets/loader_bar.gif'></div></div><div class='form-actions'> <button class='btn btn-info'  id ='close_modal'>close</button> </div></div>");
    $('#myModal').modal('show');
    $("#close_modal").live("click", function(){$('#myModal').modal('hide'); $("#myModal").hide();$("#myModal").remove();  });
    $("#closeit").live("click",function(){$('#myModal').modal('hide'); $("#myModal").hide();$("#myModal").remove(); });

});





