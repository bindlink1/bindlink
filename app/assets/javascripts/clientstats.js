

$(document).ready(function() {

    clientcntgnome();


});



function clientcntgnome() {


    $.ajax({

        type: "GET",
        dataType: "json",
        url: "/reporting/clientcnt",
        success: function(data){
            var dt = new google.visualization.DataTable();
            dt.addColumn('string', 'Carrier');
            dt.addColumn('number', 'Count');
            $.each(data.clientcnt,function(index, clientcnt){
                dt.addRow([clientcnt.policy_count ,parseInt(clientcnt.client_count)]);
            });
            var options = {

                chartArea:{width:"100%",height:"90%"},
                fontSize: 12
            };

            var chart = new google.visualization.PieChart(document.getElementById('carriercntchart'));
            chart.draw(dt, options);


        }


    });





};

