$(".trbutton").live("click",function(t){$(t.target).closest("td").html("<img width='25px' height='25px' src='/assets/ajax-loader.gif' alt='Check'>")}),$(".deleteal").live("click",function(t){$(t.target).closest("tr").slideUp(300)});