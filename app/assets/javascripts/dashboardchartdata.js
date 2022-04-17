$(document).ready(function() {
    npcgnome();
    ccgnome();
    ytd();
    ytd2();
    carriercntnome();
    $("#startdate").datepicker();
    $("#enddate").datepicker();
    $("#startdatelist").datepicker();
    $("#enddatelist").datepicker();
});


function getMonths() {
    var months = new Array(12);
    months[1] = "January";
    months[2] = "February";
    months[3] = "March";
    months[4] = "April";
    months[5] = "May";
    months[6] = "June";
    months[7] = "July";
    months[8] = "August";
    months[9] = "September";
    months[10] = "October";
    months[11] = "November";
    months[12] = "December";
    return months;
}


function ytd() {
    if( $('#ytdchart').length == 0 ) return;
    var months = getMonths();

    $.ajax({
        type: "GET",
        dataType: "json",
        url: "/dashbardlanding/premiumfornonwcmonthly",
        success: function(data){

            var dt = new google.visualization.DataTable();
            dt.addColumn('string', 'Month');
            dt.addColumn('number', 'Premium');
            $.each(data.premium,function(index, premium){
                dt.addRow([months[premium.book_month],parseFloat(premium.premium)]);
            });

            var options = {
                legend: {position: 'none'},
                vAxis: {title: 'Dollars',  titleTextStyle: {color: 'grey'}},
                chartArea:{left:60,top:10, bottom:10, right: 10,width:"100%",height:"75%"},
                fontSize: 12,
                pointSize: 5
            };
            var formatter = new google.visualization.NumberFormat({prefix: '$', negativeColor: 'red', negativeParens: true});
            formatter.format(dt,1);

            var chart = new google.visualization.LineChart(document.getElementById('ytdchart'));

            chart.draw(dt, options);
        }
    });
};


function ytd2() {
    if( $('#ytd2chart').length == 0 ) return;
    var months = getMonths();

    $.ajax({
        type: "GET",
        dataType: "json",
        url: "/dashbardlanding/premiumforwcmonthly",
        success: function(data){

            var dt = new google.visualization.DataTable();
            dt.addColumn('string', 'Month');
            dt.addColumn('number', 'Premium');
            $.each(data.premium,function(index, premium){
                dt.addRow([months[premium.book_month],parseFloat(premium.premium)]);
            });

            var options = {
                legend: {position: 'none'},
                vAxis: {title: 'Dollars',  titleTextStyle: {color: 'grey'}},
                chartArea:{left:60,top:10, bottom:10, right: 10,width:"100%",height:"75%"},
                fontSize: 12,
                pointSize: 5
            };
            var formatter = new google.visualization.NumberFormat({prefix: '$', negativeColor: 'red', negativeParens: true});
            formatter.format(dt,1);

            var chart = new google.visualization.LineChart(document.getElementById('ytd2chart'));

            chart.draw(dt, options);
        }
    });
};


function npcgnome() {
    if( $('#chart_div').length == 0 ) return;
    var months = getMonths();

    $.ajax({

        type: "GET",
        dataType: "json",
        url: "/dashbardlanding/policycountchart",
        success: function(data){
            var dt = new google.visualization.DataTable();
            var tmpyr
            var tmpmo
            var tmpnew
            var tmprenew
            dt.addColumn('string', 'Month');
            dt.addColumn('number', 'Renew');
            dt.addColumn('number', 'New');

            $.each(data.newpols,function(index, newpols){

                dt.addRow([months[newpols.book_month],parseInt(newpols.renewcount),parseInt(newpols.newcount)]);

            });

            var options = {
                legend: {position: 'top', textStyle: {color: 'black', fontSize: 10}},
                vAxis: {title: 'Policies',  titleTextStyle: {color: 'grey'}, gridlines:{color: '#333', count: 4} },
                chartArea:{left:60,top:20, bottom:20, right: 20,width:"100%",height:"75%"},
                isStacked:true,
                colors: ['#3366CC','#57BCDA'],
                fontSize: 12
            };

            var chart = new google.visualization.ColumnChart(document.getElementById('chart_div'));
            chart.draw(dt, options);
        }
    });
};


function ccgnome() {
    if( $('#commchart').length == 0 ) return;
    var months = getMonths();

    $.ajax({

        type: "GET",
        dataType: "json",
        url: "/dashbardlanding/commissionchart",
        success: function(data){

            var dt = new google.visualization.DataTable();
            dt.addColumn('string', 'Month');
            dt.addColumn('number', 'Commission');
            $.each(data.comm,function(index, comm){
                dt.addRow([months[comm.book_month],parseFloat(comm.commission)]);

            });

            var options = {
                legend: {position: 'none'},
                vAxis: {title: 'Dollars',  titleTextStyle: {color: 'grey'}},
                chartArea:{left:60,top:10, bottom:10, right: 10,width:"100%",height:"75%"},
                fontSize: 12,
                pointSize: 5
            };
            var formatter = new google.visualization.NumberFormat({prefix: '$', negativeColor: 'red', negativeParens: true});
            formatter.format(dt,1);

            var chart = new google.visualization.LineChart(document.getElementById('commchart'));

            chart.draw(dt, options);
        }
    });
};


function carriercntnome() {
    if( $('#carriercntchart').length == 0 ) return;

    $.ajax({

        type: "GET",
        dataType: "json",
        url: "/dashbardlanding/activepolcntbycarrier",
        success: function(data){
            var dt = new google.visualization.DataTable();
            dt.addColumn('string', 'Carrier');
            dt.addColumn('number', 'Count');
            $.each(data.carriercnt,function(index, carriercnt){
                dt.addRow([carriercnt.carrier_name ,parseInt(carriercnt.carrier_count)]);
            });
            var options = {

                chartArea:{width:"75%",height:"75%"},
                fontSize: 12
            };

            var chart = new google.visualization.PieChart(document.getElementById('carriercntchart'));
            chart.draw(dt, options);


        }


    });





};