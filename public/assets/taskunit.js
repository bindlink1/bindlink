$("#taskheaderwork").hide(),$(document).ready($(function(){$(".submitcheck").live("click",function(){$(this).parents("form:first").submit()}),$(".controlright:visible").find("tasktablewrapper").is(":hidden")&&($(".controlright:visible").find(".tasktablewrapper").slideDown(300),$(".controlright:visible").find(".taskheader").slideDown(300),$(".controlright:visible").find(".taskheaderwork").slideUp(300),$(".controlright:visible").find(".taskwork").slideDown(300).html("")),$(".tasklink").click(function(){$(".controlright:visible").find(".taskwork").slideUp(300),$(".controlright:visible").find(".taskheaderwork").slideUp(300),$(".controlright:visible").find(".tasktablewrapper").slideDown(300),$(".controlright:visible").find(".taskheader").slideDown(300),$table=$(this).closest("tr").find(".tasktable"),0==$table.length&&($table=$("#tasktable")),$table.html("<tr><td style='text-align:center; height: 200px;'><img src='/assets/loader_bar.gif'></td></tr>"),$(this).parent("li").addClass("active"),$(this).parent("li").siblings().removeClass("active")})}));