function clientcntgnome(){$.ajax({type:"GET",dataType:"json",url:"/reporting/clientcnt",success:function(n){var e=new google.visualization.DataTable;e.addColumn("string","Carrier"),e.addColumn("number","Count"),$.each(n.clientcnt,function(n,t){e.addRow([t.policy_count,parseInt(t.client_count)])});var t={chartArea:{width:"100%",height:"90%"},fontSize:12};new google.visualization.PieChart(document.getElementById("carriercntchart")).draw(e,t)}})}$(document).ready(function(){clientcntgnome()});