jQuery.fn.dataTableExt.aTypes.unshift(function(n){n="function"==typeof n.replace?n.replace(/<[\s\S]*?>/g,""):n;var r,e="0123456789-",t="0123456789.",f=!1;if(r=(n=$.trim(n)).charAt(0),-1==e.indexOf(r))return null;for(var u=1;u<n.length;u++){if(r=n.charAt(u),-1==t.indexOf(r))return null;if("."==r){if(f)return null;f=!0}}return"num-html"});