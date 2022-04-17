// This is a manifest file that'll be compiled into including all the files listed below.
// Add new JavaScript/Coffee code in separate files in this directory and they'll automatically
// be included in the compiled file accessible from http://example.com/assets/application.js
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// the compiled file.
//

//= require jquery
//= require jquery_ujs

//= require jquery-ui
//= require dataTables/jquery.dataTables
//= require date
//= require jquery.purr
//= require bootstrap
//= require jquery.remotipart
//= require jquery.validate

//= require jquery.formatCurrency-1.4.0.min.js
//= require bootstrappagination
//= require jquery-fileupload





google.load("visualization", "1", {packages:["corechart","orgchart"]});

jQuery( function($) {
    $('tbody tr[data-href]').addClass('clickable').click( function() {
        window.location = $(this).attr('data-href');
    });
});

$(document).ready(function(){
    $(function () {
        $(".pop").popover(
            {
                offset: 0,
                placement: 'right',
                show: 200,
                hide: 200,
                html: true,
                trigger: 'hover'
            }
        );
    });

    $('#alert').hide();
    $('#alert').slideDown(400);
    $.ajaxSetup({ cache: false });

    $('#loadingDiv').hide()  // hide it initially
        .ajaxStart(function() {
            $(this).show();
            $(this).addClass('modal');

            $(this).modal({
                show : true,
                keyboard : true,
                backdrop : false
            });

        })
        .ajaxStop(function() {
            $(this).modal('hide');
        })


        .ajaxComplete(function() {
            $(this).modal('hide');
        })
        ;

    // Javascript to enable link to tab
    var hash = document.location.hash;
    var prefix = "tab_";
    if (hash) {
        $('.nav-tabs a[href='+hash.replace(prefix,"")+']').tab('show');
    }

// Change hash for page-reload
    $('.nav-tabs a').on('shown', function (e) {
        window.location.hash = e.target.hash.replace("#", "#" + prefix);
    });
});

function roundfix(x){
    var temp = x;
    temp = Math.round((x*1000000000));
    temp = Math.round(temp/10);

    temp = Math.round((x*10000000));
    temp = Math.round(temp/10);

    temp = Math.round((x*100000));
    temp = Math.round(temp/10);

    temp = Math.round((x*1000));
    temp = Math.round(temp/10);

    temp = temp/100;

    return temp
}



function addCommas(nStr)
{
    nStr += '';
    x = nStr.split('.');
    x1 = x[0];
    x2 = x.length > 1 ? '.' + x[1] : '';
    var rgx = /(\d+)(\d{3})/;
    while (rgx.test(x1)) {
        x1 = x1.replace(rgx, '$1' + ',' + '$2');

    }
    return x1 + x2;
}




$(function(){
    $("#clients").dataTable(


            {

                "sPaginationType": "bootstrap",
                "bServerSide": true,
                "sAjaxSource": $('#clients').data('source'),
                "oLanguage": {
                    "sLengthMenu": "Display _MENU_ Clients" ,
                    "sZeroRecords": "No Clients match your search!",
                    "sEmptyTable": "No data available in table",
                    "sInfo": "Showing (_START_ to _END_) of _TOTAL_ Clients",
                    "sSearch": "Search Clients:" ,
                    "sProcessing": "Processing",
                    "sInfoFiltered": " - searching from _MAX_ Clients"
                }

            }


        );


});



$(function(){
    $("#clientpolicies").dataTable(

        {

            "sPaginationType": "bootstrap",

            "oLanguage": {
                "sLengthMenu": "Display _MENU_ Clients" ,
                "sZeroRecords": "No clients match your search!",
                "sEmptyTable": "No data available in table",
                "sInfo": "Showing (_START_ to _END_) of _TOTAL_ Clients",
                "sSearch": "Search Clients:" ,
                "sProcessing": "Processing",
                "sInfoFiltered": " - searchinging from _MAX_ Clients" },



            "bFilter": false,
            "bLengthChange": false,
            "bInfo": false,
            "bSort": true,

            "aaSorting" : [[2,'asc']]

        }

    );
});

$(function(){
    $("#referrers").dataTable(

        {

            "sPaginationType": "bootstrap",

            "oLanguage": {
                "sLengthMenu": "Display _MENU_ Referrers" ,
                "sZeroRecords": "No referrers match your search!",
                "sEmptyTable": "No data available in table",
                "sInfo": "Showing (_START_ to _END_) of _TOTAL_ Referrers",
                "sSearch": "Search Referrers:" ,
                "sProcessing": "Processing",
                "sInfoFiltered": " - searchinging from _MAX_ Referrers" }


        }

    );
});


$(function(){
    $("#invoices").dataTable(

        {

            "sPaginationType" : "full_numbers",
            "bJQueryUI" : true


        }

    );
});

$(function(){
    $("#overdueinvoices").dataTable(

        {

            "sPaginationType" : "full_numbers",
            "bJQueryUI" : true


        }

    );
});

$.extend($.fn.dataTableExt.oStdClasses, {
    "sSortAsc": "header headerSortDown",
    "sSortDesc": "header headerSortUp",
    "sSortable": "header" ,
    "sSortColumn" : "columnsorted"
} );

function removeMyModal(){
    $('#myModal').modal('hide');
    $("#myModal").hide();
    $("#myModal").remove();
}

function showMyModal( h3, htmlContent ){
    removeMyModal();
    $("#wrapper").append("<div class='modal wellwhiteblock' id='myModal' style='overflow: hidden;'><div class='wellwhitemenu'><button type='button' class='close' data_dismiss='modal' aria_hidden='true' id ='closeit'>×</button><h3>" + h3 + "</h3></div><div class='modal_body modalscroll' id='searchmodal'>" + htmlContent + "</div><div class='form-actions'> <button class='btn btn-info'  id ='close_modal'>close</button> </div></div>");
    $('#myModal').modal('show');
    $("#close_modal").on("click", removeMyModal );
    $("#closeit").on("click", removeMyModal );
}

$(function(){
    $("#policies").dataTable(
        {
            "sPaginationType": "bootstrap",
            "bServerSide": true,
            "sAjaxSource": $('#policies').data('source'),
            "searching": false,
            "oLanguage": {
                "sLengthMenu": "Display _MENU_ Policies" ,
                "sZeroRecords": "No policies match your search!",
                "sEmptyTable": "No data available in table",
                "sInfo": "Showing (_START_ to _END_) of _TOTAL_ Policies",
                "sSearch": "Search Policies:" ,
                "sProcessing": "Processing",
                "sInfoFiltered": " - searching from _MAX_ Policies"
            }
        }
    );

    $(".renewallink").on("click", function(event){
        var $a = $( event.target );
        var type = $a.hasClass('agency') ? 'Agency' : 'Direct';

        var h3 = type + ' Bill Policies: ' + $a.parent().siblings().text() + ' - click on a policy# to view.';
        var cntnt = '<div class="dataTablewrapper">\
                      <table id="renewalpolicies" class="bordered-table zebra-striped" data-source="renewal.json?i=' + event.target.id.substring(7) + '&type=' + type + '">\
                        <thead>\
                        <tr>\
                          <th>Named Insured</th>\
                          <th>Policy Number</th>\
                          <th>Expiration Date</th>\
                          <th>Carrier</th>\
                          <th>Line of Business</th>\
                          <th>Status</th>\
                          <th>Annual Premium</th>\
                        </tr>\
                        </thead>\
                        <tbody>\
                        </tbody>\
                      </table>\
                    </div>';
        showMyModal( h3, cntnt );

        $("#renewalpolicies").dataTable(
            {
                "sPaginationType": "bootstrap",
                "bServerSide": true,
                "sAjaxSource": $('#renewalpolicies').data('source'),
                "searching": false,
                "aoColumns": [
                    null,
                    null,
                    null,
                    { "bSortable": false },
                    { "bSortable": false },
                    { "bSortable": false },
                    { "bSortable": false } 
                ],
                "oLanguage": {
                    "sLengthMenu": "Display _MENU_ Policies" ,
                    "sZeroRecords": "No policies match your search!",
                    "sEmptyTable": "No data available in table",
                    "sInfo": "Showing (_START_ to _END_) of _TOTAL_ Policies",
                    "sSearch": "Search Policies:" ,
                    "sProcessing": "Processing",
                    "sInfoFiltered": " - searching from _MAX_ Policies"
                }
            }
        );

        return false;
    });


    $(".aginglink").on("click", function(event){
        var h3 = $( event.target ).parent().siblings().text() + ' invoices - click on a policy# to view.';
        var cntnt = '<div class="dataTablewrapper">\
                      <table id="agedinvoices" class="bordered-table zebra-striped" data-source="agedinvoices.json?i=' + event.target.id.substring(5) + '">\
                        <thead>\
                        <tr>\
                          <th>Producing Agency</th>\
                          <th>Policy</th>\
                          <th>Due Date</th>\
                          <th>Carrier</th>\
                          <th>Balance</th>\
                          <th>Status</th>\
                          <th>Days Past Due</th>\
                        </tr>\
                        </thead>\
                        <tbody>\
                        </tbody>\
                      </table>\
                    </div>';
        showMyModal( h3, cntnt );

        $("#agedinvoices").dataTable(
            {
                "sPaginationType": "bootstrap",
                "bServerSide": true,
                "sAjaxSource": $('#agedinvoices').data('source'),
                "searching": false,
                "aoColumns": [
                    null,
                    null,
                    null,
                    { "bSortable": false },
                    { "bSortable": false },
                    { "bSortable": false },
                    { "bSortable": false } 
                ],
                "oLanguage": {
                    "sLengthMenu": "Display _MENU_ Policies" ,
                    "sZeroRecords": "No policies match your search!",
                    "sEmptyTable": "No data available in table",
                    "sInfo": "Showing (_START_ to _END_) of _TOTAL_ Policies",
                    "sSearch": "Search Policies:" ,
                    "sProcessing": "Processing",
                    "sInfoFiltered": " - searching from _MAX_ Policies"
                }
            }
        );

        return false;
    });


    $(".insert-tag li a").live("click", function(event){
        $( event.target ).parent().parent().parent().siblings("textarea").insertAtCaret("<#" + event.target.id + "#>");

        return false;
    });

    if ($("#emaillog").length) {
        var emailLogQuery = /policies/.test(document.location.pathname)
            ? $('#pageheader').text().split(':')[0].trim()
            : (document.location.search ? document.location.search.slice(1) : "");


        $("#emaillog").dataTable({
            "sPaginationType": "bootstrap",
            "bServerSide": true,
            "sAjaxSource": $('#emaillog').data('source'),
            "oSearch": {
                "sSearch": emailLogQuery
            },
            "order": [[ 1, "desc" ]],
            "oLanguage": {
                "sLengthMenu": "Display _MENU_ Emails" ,
                "sZeroRecords": "No emails match your search!",
                "sEmptyTable": "No data available in table",
                "sInfo": "Showing (_START_ to _END_) of _TOTAL_ Emails",
                "sSearch": "Search Emails:" ,
                "sProcessing": "Processing",
                "sInfoFiltered": " - searching from _MAX_ Emails"
            }
        });
    }
});


$(function(){
    $("#emails").dataTable(

        {

            "sPaginationType": "bootstrap",

            "oLanguage": {
                "sLengthMenu": "Display _MENU_ Emails" ,
                "sZeroRecords": "No emails match your search!",
                "sEmptyTable": "No data available in table",
                "sInfo": "Showing (_START_ to _END_) of _TOTAL_ Emails",
                "sSearch": "Search Emails:" ,
                "sProcessing": "Processing",
                "sInfoFiltered": " - searching from _MAX_ Emails"
            }

        }


    );



});

$(function(){
    $("#submissions").dataTable(

        {

            "sPaginationType": "bootstrap",

            "oLanguage": {
                "sLengthMenu": "Display _MENU_ Submissions" ,
                "sZeroRecords": "No submissions match your search!",
                "sEmptyTable": "No submissions",
                "sInfo": "Showing (_START_ to _END_) of _TOTAL_ Submissions",
                "sSearch": "Search Submissions:" ,
                "sProcessing": "Processing",
                "sInfoFiltered": " - searchinging from _MAX_ Submissions"
            }

        }


    );



});






$(function(){
    $("#producingagencies").dataTable(

        {

            "sPaginationType": "bootstrap",
            "bFilter": false,
            "bServerSide": true,
            "sAjaxSource": $('#producingagencies').data('source'),
            "oLanguage": {
                "sLengthMenu": "Display _MENU_ Producers" ,
                "sZeroRecords": "No Producers match your search!",
                "sEmptyTable": "No data available in table",
                "sInfo": "Showing (_START_ to _END_) of _TOTAL_ Producers",


                "sInfoFiltered": " - searching from _MAX_ Producers"

            }

        }

    );
});

$(function(){
    $("#prospects").dataTable(

        {

            "sPaginationType": "bootstrap",

            "oLanguage": {
                "sLengthMenu": "Display _MENU_ Prospects" ,
                "sZeroRecords": "No Prospects match your search!",
                "sEmptyTable": "No Prospects",
                "sInfo": "Showing (_START_ to _END_) of _TOTAL_ Prospects",
                "sSearch": "Search Prospects:" ,
                "sProcessing": "Processing",
                "sInfoFiltered": " - searching from _MAX_ Prospects"
            }

        }

    );
});


$(function(){
    $(".topdetails").dataTable(

        {


            "bJQueryUI" : true,
            "bFilter": false,
            "bLengthChange": false,
            "bInfo": false,
            "bPaginate": false,
            "bSort": false,
            "sDom": ''

        }

    );
});

$(function(){
    $("#cashtransactions").dataTable(

        {


            "bJQueryUI" : true,
            "bFilter": false,
            "bLengthChange": false,
            "bInfo": false,
            "bPaginate": false


        }

    );
});




!function ($) {

    "use strict"; // jshint ;_;


    /* DROPDOWN CLASS DEFINITION
     * ========================= */

    var toggle = '[data-toggle="dropdown"]'
        , Dropdown = function (element) {
        var $el = $(element).on('click.dropdown.data-api', this.toggle)
        $('html').on('click.dropdown.data-api', function () {
            $el.parent().removeClass('open')
        })
    }

    Dropdown.prototype = {

        constructor: Dropdown

        , toggle: function (e) {
            var $this = $(this)
                , $parent
                , selector
                , isActive

            if ($this.is('.disabled, :disabled')) return

            selector = $this.attr('data-target')

            if (!selector) {
                selector = $this.attr('href')
                selector = selector && selector.replace(/.*(?=#[^\s]*$)/, '') //strip for ie7
            }

            $parent = $(selector)
            $parent.length || ($parent = $this.parent())

            isActive = $parent.hasClass('open')

            clearMenus()

            if (!isActive) $parent.toggleClass('open')

            return false
        }

    }

    function clearMenus() {
        $(toggle).parent().removeClass('open')
    }


    /* DROPDOWN PLUGIN DEFINITION
     * ========================== */

    $.fn.dropdown = function (option) {
        return this.each(function () {
            var $this = $(this)
                , data = $this.data('dropdown')
            if (!data) $this.data('dropdown', (data = new Dropdown(this)))
            if (typeof option == 'string') data[option].call($this)
        })
    }

    $.fn.dropdown.Constructor = Dropdown


    /* APPLY TO STANDARD DROPDOWN ELEMENTS
     * =================================== */

    $(function () {
        $('html').on('click.dropdown.data-api', clearMenus)
        $('body')
            .on('click.dropdown', '.dropdown form', function (e) { e.stopPropagation() })
            .on('click.dropdown.data-api', toggle, Dropdown.prototype.toggle)
    })

}(window.jQuery);

jQuery.fn.extend({
insertAtCaret: function(myValue){
  return this.each(function(i) {
    if (document.selection) {
      //For browsers like Internet Explorer
      this.focus();
      var sel = document.selection.createRange();
      sel.text = myValue;
      this.focus();
    }
    else if (this.selectionStart || this.selectionStart == '0') {
      //For browsers like Firefox and Webkit based
      var startPos = this.selectionStart;
      var endPos = this.selectionEnd;
      var scrollTop = this.scrollTop;
      this.value = this.value.substring(0, startPos)+myValue+this.value.substring(endPos,this.value.length);
      this.focus();
      this.selectionStart = startPos + myValue.length;
      this.selectionEnd = startPos + myValue.length;
      this.scrollTop = scrollTop;
    } else {
      this.value += myValue;
      this.focus();
    }
  });
}
});