$(document).ready($(function(){function e(){var e=$("#quote_carrier_id").val();$.ajax({type:"GET",dataType:"json",data:"carrier_id="+e,url:"/policies/carrierlobs",success:function(e){$("#quote_lineofbusiness_id").html(""),$("<option value=''>Select One</option>").appendTo("#submission_quote_lineofbusiness_id"),$.each(e.lobs,function(e,i){$("<option value='"+i.id+"'>"+i.line_name+"</option>").appendTo("#quote_lineofbusiness_id")}),$("#quote_lineofbusiness_id").removeAttr("disabled"),$("#quote_lineofbusiness_id").effect("highlight",1e3)}})}$("#quote_lineofbusiness_id").attr("disabled","disabled"),$("#quote_carrier_id").change(function(){e()})}));